import UIKit
import SwiftyDropbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        Dropbox.setupWithAppKey("m1ngt61jtc7wr7g")
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        openedAppFromUrl(url)
        return false
    }

	func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
		openedAppFromUrl(url)
		return false
	}
	
	private func openedAppFromUrl(url: NSURL) {
		if let authResult = Dropbox.handleRedirectURL(url) {
			switch authResult {
			case .Success(let token):
				print("Success! Access token is: \(token)")
			case .Error(let error, let description):
				print("Error: \(error) and Desc: \(description)")
			}
		}

	}

}

