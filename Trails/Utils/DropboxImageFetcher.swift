import Foundation
import SwiftyDropbox
import Haneke

class DropboxImageFetcher: ImageFetcherProtocol {
	
	private var imagePath: String
	private var imageSize: Files.ThumbnailSize
	
	init(imagePath: String, imageSize: Files.ThumbnailSize) {
		self.imagePath = imagePath
		self.imageSize = imageSize
	}
	
	func getImagePath() -> String {
		return imagePath
	}
	
	func fetch(successCallback: ((UIImage, String) -> Void), failureCallback: (NSError? -> Void)?) {
		Dropbox.authorizedClient?.filesGetThumbnail(path: imagePath, size: imageSize).response { response, error in
			if let (_, data) = response {
				let image = UIImage(data: data)!
				
				Shared.imageCache.set(value: image, key: self.imagePath)
				successCallback(image, self.imagePath)
			} else {
				failureCallback?(NSError(domain: error!.description, code: 0, userInfo: nil))
			}
		}
	}
}
