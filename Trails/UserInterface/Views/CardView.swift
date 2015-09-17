import Foundation
import UIKit
import SwiftyDropbox
import SwiftDate

class CardView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
 
    func render(trail: Trail) {
        self.dateLabel.hidden = true
        activityIndicator.startAnimating()
        thumbNailFor(trail.mediaPath) { (image: UIImage) -> Void in
            self.activityIndicator.stopAnimating()
            self.dateLabel.hidden = false
            self.dateLabel.text = trail.createdAt.toRelativeString(abbreviated: false, maxUnits: 1).uppercaseString.stringByReplacingOccurrencesOfString("ABOUT", withString: "")
            self.imageView.image = image
        }
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
