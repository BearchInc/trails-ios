import Foundation
import UIKit
import SwiftyDropbox
import SwiftDate
import Haneke

class CardView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
 
    func render(trail: Trail) {
        self.dateLabel.hidden = true
        activityIndicator.startAnimating()
        getCachedThumbnail(trail)
    }
    
    private func thumbNailFor(path: String, completionHandler: ((NSData) -> Void)) {
        Dropbox.authorizedClient?.filesGetThumbnail(path: path, size: Files.ThumbnailSize.W1024h768).response { response, error in
            if let (_, data) = response {
                completionHandler(data)
            } else {
                print(error!)
            }
        }
    }
    
    private func getCachedThumbnail(trail: Trail) {
        let cache = Shared.dataCache

        cache.fetch(key: trail.mediaPath).onSuccess { imageData in
            self.setupImage(trail, image: UIImage(data: imageData)!)
        }.onFailure { _ in
            self.thumbNailFor(trail.mediaPath) { (imageData) in
                cache.set(value: imageData, key: trail.mediaPath)
                self.setupImage(trail, image: UIImage(data: imageData)!)
            }
        }
    }
    
    private func setupImage(trail: Trail, image: UIImage) {
        self.activityIndicator.stopAnimating()
        self.dateLabel.hidden = false
        self.dateLabel.text = trail.createdAt.toRelativeString(abbreviated: false, maxUnits: 1).uppercaseString.stringByReplacingOccurrencesOfString("ABOUT", withString: "")
        self.imageView.image = image
    }
    
}
