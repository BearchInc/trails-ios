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
        dateLabel.hidden = true
        activityIndicator.startAnimating()
        fetchAndRenderImage(trail, completion: renderTrail)
    }
    
    private func fetchAndRenderImage(trail: Trail, completion: (trail: Trail, image: UIImage) -> Void) {
        let cache = Shared.imageCache

        cache.fetch(key: trail.mediaPath).onSuccess { image in
            completion(trail: trail, image: image)
        }.onFailure { _ in
            self.thumbNailFor(trail.mediaPath) { (image) in
                cache.set(value: image, key: trail.mediaPath)
                completion(trail: trail, image: image)
            }
        }
    }
    
    private func renderTrail(trail: Trail, image: UIImage) {
        self.activityIndicator.stopAnimating()
        self.dateLabel.hidden = false
        self.dateLabel.text = trail.createdAt.toRelativeString(abbreviated: false, maxUnits: 1).uppercaseString.stringByReplacingOccurrencesOfString("ABOUT", withString: "")
        self.imageView.image = image
    }
    
    private func thumbNailFor(path: String, completionHandler: ((UIImage) -> Void)) {
        Dropbox.authorizedClient?.filesGetThumbnail(path: path, size: Files.ThumbnailSize.W1024h768).response { response, error in
            if let (_, data) = response {
                completionHandler(UIImage(data: data)!)
            } else {
                print(error!)
            }
        }
    }
}
