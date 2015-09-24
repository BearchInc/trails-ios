import Foundation
import UIKit

class StoryViewController: UIViewController {

	@IBOutlet weak var image: UIImageView!

	var story: Story!

	private var imagesProvider: ImagesProvider!
	private var trails: [Trail]!
	private var imageProvider: ImageProvider!
	private var images = [UIImage]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		fetchData()
	}
	
	private func fetchData() {
		story.fetchTrails(fetchTrailsCallback)
	}
	
	private func fetchTrailsCallback(trails: [Trail]?, error: ErrorType?) {
		self.trails = trails
		let trailsUrls = self.trails.map(trailsToUrls)
		imagesProvider = ImagesProvider(imagePaths: trailsUrls, imageDownloadedCallback: imageDownloadedCallback)
		imagesProvider.provide()
	}
	
	private func imageDownloadedCallback(index: Int, image: UIImage) {
		print("Downloaded image at index \(index)")
		images.append(image)

		UIView.transitionWithView(self.image, duration: 0.5, options: .Autoreverse, animations: { () -> Void in
				self.image.image = image
		}, completion: nil)
		
	}
	
	private func trailsToUrls(trail: Trail) -> String {
		return trail.mediaPath
	}
	
	private func successCallback(image: UIImage, path: String) {
		self.image.image = image
	}
	
	private func failureCallback(error: NSError?) {
		print(error)
	}
	
	
}
