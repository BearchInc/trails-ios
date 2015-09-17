import Foundation
import UIKit
import SwiftyDropbox
import SwiftDate
import Haneke

class CardView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var trail: Trail!
    
    func render(trail: Trail) {
        self.trail = trail
        activityIndicator.startAnimating()
        fetchAndRenderImage()
    }
    
    private func fetchAndRenderImage() {
        Shared.imageCache.fetch(key: trail.mediaPath)
            .onSuccess (renderTrail)
            .onFailure (handleCacheMiss)
    }
    
    private func handleCacheMiss(error: NSError?) {
        fetchThumbnail(trail.mediaPath, completionHandler: renderTrail)
    }
    
    private func renderTrail(image: UIImage) {
        activityIndicator.stopAnimating()
        dateLabel.hidden = false
        dateLabel.text = trail.createdAt.toRelativeString(abbreviated: false, maxUnits: 1).uppercaseString.stringByReplacingOccurrencesOfString("ABOUT", withString: "")
        imageView.image = image
    }
    
    private func fetchThumbnail(path: String, completionHandler: (UIImage -> Void)) {
        Dropbox.authorizedClient?.filesGetThumbnail(path: path, size: Files.ThumbnailSize.W1024h768).response { response, error in
            if let (_, data) = response {
                let image = UIImage(data: data)!

                Shared.imageCache.set(value: image, key: self.trail.mediaPath)
                completionHandler(image)
            } else {
                print(error!)
            }
        }
    }
}
