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
	
	private var slider: ImageSlider?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		fetchData()
	}
	
	private func fetchData() {
		story.fetchTrails(fetchTrailsCallback)
	}
	
	private func fetchTrailsCallback(trails: [Trail]?, error: ErrorType?) {
		self.trails = trails
		slider = ImageSlider(trails: trails, displayImageCallback: displayImageCallback, completionCallback: finish)
		slider!.start()
	}
	
	private func displayImageCallback(image: UIImage) {
		trailImage.image = image
	}
	
	private func successCallback(image: UIImage, path: String) {
		trailImage.image = image
	}
	
	private func failureCallback(error: NSError?) {
		print(error)
	}
	
	private func finish() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func didTapTrailImage(sender: AnyObject) {		
		slider?.next()
	}
	
	@IBAction func didTapCloseButton(sender: AnyObject) {
		finish()
	}

}
