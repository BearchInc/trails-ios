import UIKit
import SwiftyDropbox

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        verifyUserLoggedInDropbox()
    }
    
    private func verifyUserLoggedInDropbox() {
        if let client = Dropbox.authorizedClient {
            let userId = DropboxAuthManager.sharedAuthManager.getAllAccessTokens().keys.first!
            let authToken = DropboxAuthManager.sharedAuthManager.getAccessToken(user: userId)
            
            Account.instance.registerDropbox(userId, accessToken: authToken!.description)
        }
    }
    
    @IBAction func linkButtonPressed(sender: AnyObject) {
        if (Dropbox.authorizedClient == nil) {
            Dropbox.authorizeFromController(self)
        } else {
            print("User is already authorized!")
        }
    }
}