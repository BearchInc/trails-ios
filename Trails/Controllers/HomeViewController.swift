import UIKit
import SwiftyDropbox

class HomeViewController: UIViewController {
    
    @IBOutlet weak var toggleDropboxLink: UIBarButtonItem!

    override func viewDidAppear(animated: Bool) {
        verifyDropboxAuthorization()
    }
    
    func verifyDropboxAuthorization() {
        if let authorizedClient = Dropbox.authorizedClient {
            toggleDropboxLink.title = "Unlink from Dropbox"
            let userId = DropboxAuthManager.sharedAuthManager.getAllAccessTokens().keys.array.last!
            let authToken = DropboxAuthManager.sharedAuthManager.getAccessToken(user: userId)
            
            Account.instance.registerDropbox(userId, accessToken: authToken!.description)
            authorizedClient.usersGetCurrentAccount().response { response, error in
                if let account = response {
                    Account.instance.update(account)
                } else {
                    println(error!)
                }
            }
            
        } else {
            toggleDropboxLink.title = "Link with Dropbox"
        }
    }
    
    @IBAction func didTapDropboxLink(sender: AnyObject) {
        if let authorized = Dropbox.authorizedClient {
            DropboxAuthManager.sharedAuthManager.clearStoredAccessTokens()
            verifyDropboxAuthorization()
        } else {
           Dropbox.authorizeFromController(self)
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