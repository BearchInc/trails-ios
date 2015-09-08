import UIKit
import SwiftyDropbox

class HomeViewController: UIViewController {
    
    @IBOutlet weak var toggleDropboxLink: UIBarButtonItem!

    override func viewDidAppear(animated: Bool) {
        verifyDropboxAuthorization()
    }
    
    func verifyDropboxAuthorization() {
        if let authorizedClient = Dropbox.authorizedClient {
            
            let dropboxAccessTokens = DropboxAuthManager.sharedAuthManager.getAllAccessTokens().keys.array

            if dropboxAccessTokens.count > 0 {
                toggleDropboxLink.title = "Unlink from Dropbox"
                let userId = dropboxAccessTokens.last!
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
                Dropbox.unlinkClient()
                sleep(1)
                verifyDropboxAuthorization()
            }
        } else {
            toggleDropboxLink.title = "Link with Dropbox"
        }
    }
    
    @IBAction func didTapDropboxLink(sender: AnyObject) {
        if let authorized = Dropbox.authorizedClient {
            Dropbox.unlinkClient()
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