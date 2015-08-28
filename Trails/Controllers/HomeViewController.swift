import UIKit
import SwiftyDropbox

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        println(Account.instance)

        // Verify user is logged into Dropbox
        if let client = Dropbox.authorizedClient {
            let userId = DropboxAuthManager.sharedAuthManager.getAllAccessTokens().keys.first!
            let authToken = DropboxAuthManager.sharedAuthManager.getAccessToken(user: userId)
//            DropboxAuthManager.sharedAuthManager
//            Account.instance.registerDropbox(, DropboxAuthManager.sharedAuthManager.getFirstAccessToken()!.description)
            
            Account.instance.registerDropbox(userId, accessToken: authToken!.description)
            
            
            // Get the current user's account info
            client.usersGetCurrentAccount().response { response, error in
                if let dropboxAccount = response {
                    
                    Account.instance.update(dropboxAccount)
                } else {
                    println(error!)
                }
            }
            
            // List folder
            client.filesListFolder(path: "").response { response, error in
                if let result = response {
                    println("Folder contents:")
                    for entry in result.entries {
                        println(entry.name)
                    }
                } else {
                    println(error!)
                }
            }
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