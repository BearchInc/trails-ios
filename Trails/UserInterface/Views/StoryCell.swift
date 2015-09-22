import Foundation
import UIKit
import SwiftyDropbox
import Haneke

class StoryCell: UICollectionViewCell {
	
	@IBOutlet weak var mainImage: UIImageView!
	@IBOutlet weak var storyTitle: UILabel!
	
	var story: Story!
	
	func render(story: Story) {
		self.story = story
		storyTitle.text = story.title
		fetchAndRenderImage()
		addBorder()
	}
	
	private func addBorder() {
		let borderWidth: CGFloat = 1.0
		
//		self.frame = CGRectInset(self.frame, -borderWidth, -borderWidth);
		self.layer.borderColor = UIColor.whiteColor().CGColor
		self.layer.borderWidth = borderWidth
	}

	private func fetchAndRenderImage() {
		Shared.imageCache.fetch(key: story.imagePath)
			.onSuccess (renderStory)
			.onFailure (handleCacheMiss)
	}
	
	private func handleCacheMiss(error: NSError?) {
		fetchThumbnail(story.imagePath, completionHandler: renderStory)
	}
	
	private func renderStory(image: UIImage) {
//		activityIndicator.stopAnimating()
		mainImage.image = image
	}
	
	private func fetchThumbnail(path: String, completionHandler: (UIImage -> Void)) {
		Dropbox.authorizedClient?.filesGetThumbnail(path: path, size: Files.ThumbnailSize.W1024h768).response { response, error in
			if let (_, data) = response {
				let image = UIImage(data: data)!
				Shared.imageCache.set(value: image, key: self.story.imagePath)
				completionHandler(image)
			} else {
				print(error!)
			}
		}
	}

}
