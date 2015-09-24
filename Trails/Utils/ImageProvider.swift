import Foundation
import UIKit
import Haneke
import SwiftyDropbox

class ImageProvider {
	
	var successCallback: ((UIImage, String) -> Void)
	var failureCallback: (NSError -> Void)?
	var imagePath: String
	
	init(imagePath: String, successCallback: ((UIImage, String) -> Void), failureCallback: (NSError -> Void)?) {
		self.imagePath = imagePath
		self.successCallback = successCallback
		self.failureCallback = failureCallback
	}
	
	func fetchImage() -> Self {
		Shared.imageCache.fetch(key: imagePath)
			.onSuccess (fechSuccess)
			.onFailure (handleCacheMiss)
		return self
	}
	
	private func handleCacheMiss(error: NSError?) {
		DropboxImageFetcher().fetch(imagePath, successCallback: successCallback, failureCallback: failureCallback)
	}
	
	private func fechSuccess(image: UIImage) {
		self.successCallback(image, imagePath)
	}
	
}

class DropboxImageFetcher {
	func fetch(path: String, successCallback: ((UIImage, String) -> Void), failureCallback: (NSError -> Void)?) {
		Dropbox.authorizedClient?.filesGetThumbnail(path: path, size: Files.ThumbnailSize.W1024h768).response { response, error in
			if let (_, data) = response {
				let image = UIImage(data: data)!
				
				Shared.imageCache.set(value: image, key: path)
				successCallback(image, path)
			} else {
				failureCallback?(NSError(domain: error!.description, code: 0, userInfo: nil))
			}
		}
	}
}
