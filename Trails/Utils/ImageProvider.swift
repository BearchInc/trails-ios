import Foundation
import UIKit
import Haneke
import SwiftyDropbox

class ImageProvider {
	
	var successCallback: ((UIImage, String) -> Void)!
	var failureCallback: (NSError -> Void)!
	
	var imagePath: String
	
	init(imagePath: String) {
		self.imagePath = imagePath
	}
	
	func fetchImage() -> Self {
		Shared.imageCache.fetch(key: imagePath)
			.onSuccess (fechSuccess)
			.onFailure (handleCacheMiss)
		return self
	}
	
	func onSuccess(success: ((UIImage, String) -> Void)) -> Self {
		self.successCallback = success
		return self
	}
	
	func onFailure(failure: (NSError -> Void)) -> Self {
		self.failureCallback = failure
		return self
	}
	
	private func handleCacheMiss(error: NSError?) {
		fetchThumbnail(imagePath, completionHandler: fechSuccess)
	}
	
	private func fechSuccess(image: UIImage) {
		self.successCallback(image, imagePath)
	}
	
	private func fetchThumbnail(path: String, completionHandler: (UIImage -> Void)) {
		Dropbox.authorizedClient?.filesGetThumbnail(path: path, size: Files.ThumbnailSize.W1024h768).response { response, error in
			if let (_, data) = response {
				let image = UIImage(data: data)!
				
				Shared.imageCache.set(value: image, key: self.imagePath)
				completionHandler(image)
			} else {
				self.failureCallback(NSError(domain: error!.description, code: 0, userInfo: nil))
			}
		}
	}
}
