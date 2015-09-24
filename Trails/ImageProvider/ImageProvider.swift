import Foundation
import UIKit
import Haneke
import SwiftyDropbox

class ImageProvider {
	
	private var successCallback: ((UIImage, String) -> Void)
	private var failureCallback: (NSError? -> Void)?
	private var fetcher: ImageFetcherProtocol
	
	init(fetcher: ImageFetcherProtocol, successCallback: ((UIImage, String) -> Void), failureCallback: (NSError? -> Void)?) {
		self.fetcher = fetcher
		self.successCallback = successCallback
		self.failureCallback = failureCallback
	}
	
	func fetchImage() -> Self {
		Shared.imageCache.fetch(key: fetcher.getImagePath())
			.onSuccess (fechSuccess)
			.onFailure (handleCacheMiss)
		return self
	}
	
	private func handleCacheMiss(error: NSError?) {
		fetcher.fetch(successCallback, failureCallback: failureCallback)
	}
	
	private func fechSuccess(image: UIImage) {
		successCallback(image, fetcher.getImagePath())
	}
}
