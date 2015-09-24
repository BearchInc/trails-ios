import Foundation
import UIKit

protocol ImageFetcherProtocol {
	func fetch(successCallback: ((UIImage, String) -> Void), failureCallback: (NSError? -> Void)?)
	func getImagePath() -> String
}