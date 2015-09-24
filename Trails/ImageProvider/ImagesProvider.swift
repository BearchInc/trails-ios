import Foundation
import UIKit

class ImagesProvider {
	
	private var imageProviders: [ImageProvider]!
	private var downloadedImageAtIndex = -1
	private var onImageDownloaded: ((Int, UIImage) -> Void)
	private var isStopped = false
	
	init(imagePaths: [String]!, imageDownloadedCallback: ((Int, UIImage) -> Void)) {
		onImageDownloaded = imageDownloadedCallback
		imageProviders = imagePaths.map(urlToImageProvider)
	}
	
	func provide() {
		guard shouldContinue() else {
			return
		}
		
		let provider = imageProviders.removeFirst()
		provider.fetchImage()
	}
	
	func stop() {
		isStopped = true
	}
	
	private func shouldContinue() -> Bool {
		return !isStopped && !imageProviders.isEmpty
	}
	
	private func urlToImageProvider(imagePath: String) -> ImageProvider {
		let fetcher = DropboxImageFetcher(imagePath: imagePath)
		return ImageProvider(fetcher: fetcher, successCallback: successCallback, failureCallback: failureCallback)
	}
	
	private func successCallback(image: UIImage, imagePath: String) {
		downloadedImageAtIndex++
		onImageDownloaded(downloadedImageAtIndex, image)
		provide()
	}
	
	private func failureCallback(error: NSError?) {
		provide()
	}
}
