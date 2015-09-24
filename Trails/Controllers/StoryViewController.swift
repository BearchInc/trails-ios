import Foundation
import UIKit

class StoryViewController: UIViewController {

	@IBOutlet weak var trailImage: UIImageView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!

	
	var story: Story!

	private var imagesProvider: ImagesProvider!
	private var trails: [Trail]!
	private var imageProvider: ImageProvider!
	private var images = [UIImage]()
	private var currentShowingImage = -1
	private var waitingForImage = 0
	
	private var slider: ImageSlider?
	private var timer: NSTimer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		fetchData()
	}
	
	private func fetchData() {
		story.fetchTrails(fetchTrailsCallback)
	}
	
	private func fetchTrailsCallback(trails: [Trail]?, error: ErrorType?) {
		self.trails = trails
		slider = ImageSlider(trails: trails, displayImageCallback: displayImageCallback, displayPlaceHolderCallback: displayPlaceHolderCallback, completionCallback: finish)
		slider!.start()
	}
	
	private func displayImageCallback(image: UIImage) {
		invalidateTimer()
		setupTimer()
		trailImage.image = image
		activityIndicator.stopAnimating()
	}
	
	private func displayPlaceHolderCallback() {
		trailImage.image = UIImage(named: "PlaceHolder")!
		activityIndicator.startAnimating()
	}

	private func finish() {
		invalidateTimer()
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func skipImage() {
		slider?.next()
	}
	
	private func setupTimer() {
		timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "skipImage", userInfo: nil, repeats: false)
	}
	
	private func invalidateTimer() {
		if let timer = timer {
			timer.invalidate()
		}
	}
	
	@IBAction func didTapTrailImage(sender: AnyObject) {		
		skipImage()
	}
	
	@IBAction func didTapCloseButton(sender: AnyObject) {
		finish()
	}

}
