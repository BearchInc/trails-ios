import Foundation
import Haneke

class WebImageFetcher: ImageFetcherProtocol {
	
	private let imagePath: String
	
	init(imagePath: String) {
		self.imagePath = imagePath
	}
	
	func fetch(successCallback: ((UIImage, String) -> Void), failureCallback: (NSError? -> Void)?) {
		Shared.imageCache.fetch(URL: NSURL(string: imagePath)!)
		.onSuccess { (image) -> () in
			successCallback(image, self.imagePath)
		}
		.onFailure { (error) -> () in
			failureCallback?(error)
		}
	}
	
	func getImagePath() -> String {
		return imagePath
	}
}
