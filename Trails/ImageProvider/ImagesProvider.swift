import Foundation
import UIKit

class ImagesProvider {
	
	private var imageProviders: [ImageProvider]!
	private var downloadedImageAtIndex = -1
	private var onImageDownloaded: ((Int, UIImage) -> Void)
	
	init(imagePaths: [String]!, imageDownloadedCallback: ((Int, UIImage) -> Void)) {
		onImageDownloaded = imageDownloadedCallback
		imageProviders = imagePaths.map(urlToImageProvider)
	}
	
	func provide() {
		if imageProviders.isEmpty {
			return
		}
		
		let provider = imageProviders.removeFirst()
		provider.fetchImage()
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
