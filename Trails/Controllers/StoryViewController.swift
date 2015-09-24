import Foundation
import UIKit

class StoryViewController: UIViewController {

	@IBOutlet weak var trailImage: UIImageView!

	var story: Story!

	private var imagesProvider: ImagesProvider!
	private var trails: [Trail]!
	private var imageProvider: ImageProvider!
	private var images = [UIImage]()
	private var currentShowingImage = -1
	private var waitingForImage = 0
	
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

		if index == waitingForImage {
			currentShowingImage++
			trailImage.image = image
		}
	}
	
	private func trailsToUrls(trail: Trail) -> String {
		return trail.mediaPath
	}
	
	private func successCallback(image: UIImage, path: String) {
		trailImage.image = image
	}
	
	private func failureCallback(error: NSError?) {
		print(error)
	}
	
	func showNextImage() {
		currentShowingImage++

		if currentShowingImage > images.count - 1 {
			waitingForImage = currentShowingImage
			trailImage.image = UIImage(named: "overlay_skip")
		} else {
			trailImage.image = images[currentShowingImage]
		}
	}
	
	private func finish() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func didTapTrailImage(sender: AnyObject) {
		
		if currentShowingImage == trails.count - 1 {
			finish()
			return
		}
		
		showNextImage()
	}
	
	@IBAction func didTapCloseButton(sender: AnyObject) {
		finish()
	}

}
