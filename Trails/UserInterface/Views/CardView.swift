import Foundation
import UIKit
import SwiftDate

class CardView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var trail: Trail!
	private var imageProvider: ImageProvider!
    
    func render(trail: Trail) {
        self.trail = trail
        activityIndicator.startAnimating()
		imageProvider = ImageProvider(imagePath: trail.mediaPath,
			successCallback: imageFetched,
			failureCallback: imageFetchFailed)
		imageProvider.fetchImage()
    }
	
	func render(image: UIImage) {
		activityIndicator.stopAnimating()
		imageView.image = image
	}
	
	private func imageFetched(image: UIImage, mediaPath: String) {
		renderTrail(image)
	}
	
	private func imageFetchFailed(error: NSError) {
		print("failed to donwload trail image \(error.description)")
	}
    
    private func renderTrail(image: UIImage) {
        activityIndicator.stopAnimating()
        dateLabel.hidden = false
        dateLabel.text = trail.createdAt.toRelativeString(abbreviated: false, maxUnits: 1).uppercaseString.stringByReplacingOccurrencesOfString("ABOUT", withString: "")
        imageView.image = image
    }
}
