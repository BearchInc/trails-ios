import Foundation
import UIKit
import SwiftyDropbox

class StoryCell: UICollectionViewCell {
	
	@IBOutlet weak var mainImage: UIImageView!
	@IBOutlet weak var storyTitle: UILabel!
	
	private var story: Story!
	private var imageProvider: ImageProvider!
	
	func render(story: Story) {
		self.story = story
		storyTitle.text = story.title
		fetchAndRenderImage()
		addBorder()
	}
	
	private func addBorder() {
		let borderWidth: CGFloat = 1.0
		self.layer.borderColor = UIColor.whiteColor().CGColor
		self.layer.borderWidth = borderWidth
	}

	private func fetchAndRenderImage() {
		var fetcher: ImageFetcherProtocol
		
		if story.authorizationType == AuthorizationType.Web {
			fetcher = WebImageFetcher(imagePath: story.imagePath)
		} else {
			fetcher = DropboxImageFetcher(imagePath: story.imagePath, imageSize: Files.ThumbnailSize.W640h480)
		}
		
		imageProvider = ImageProvider(fetcher: fetcher, successCallback: imageFetched, failureCallback: imageFetchFailed)
		imageProvider.fetchImage()
	}
	
	private func imageFetched(image: UIImage, imagePath: String) {
		guard story.imagePath == imagePath else {
			return
		}
		renderStory(image)
	}
	
	private func imageFetchFailed(error: NSError?) {
		print("failed to donwload trail image \(error?.description)")
	}
	
	private func renderStory(image: UIImage) {
		UIView.transitionWithView(mainImage,
			duration: 1,
			options: UIViewAnimationOptions.TransitionCrossDissolve,
			animations: { () -> Void in
				self.mainImage.image = image
			}, completion: nil)
	}
	
	override func prepareForReuse() {
		self.mainImage.image = UIImage(named: "PlaceHolder")
	}
	
}
