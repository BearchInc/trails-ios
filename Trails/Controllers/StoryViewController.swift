import Foundation
import UIKit

class StoryViewController: UIViewController {

	@IBOutlet weak var image: UIImageView!

	var story: Story!

	private var trails: [Trail]!
	private var imageProvider: ImageProvider!

	override func viewDidLoad() {
		super.viewDidLoad()
		fetchData()
	}
	
	private func fetchData() {
		story.fetchTrails(fetchTrailsCallback)
	}
	
	private func fetchTrailsCallback(trails: [Trail]?, error: ErrorType?) {
		self.trails = trails
		let imageFetcher = DropboxImageFetcher(imagePath: (trails?.first!.mediaPath)!)
		imageProvider = ImageProvider(fetcher: imageFetcher, successCallback: successCallback, failureCallback: failureCallback)
		imageProvider.fetchImage()
	}
	
	private func successCallback(image: UIImage, path: String) {
		self.image.image = image
	}
	
	private func failureCallback(error: NSError?) {
		print(error)
	}
	
	
}
