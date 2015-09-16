import Foundation
import UIKit
import SwiftyDropbox

class CardView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
 
    func render(trail: Trail) {
        
        dateLabel.text = trail.createdAt.description
        thumbNailFor(trail.mediaPath) { (image: UIImage) -> Void in
            self.imageView.image = image
            self.imageView.sizeToFit()
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
