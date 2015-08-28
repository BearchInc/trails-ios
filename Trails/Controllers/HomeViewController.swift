import UIKit
import SwiftyDropbox

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        println(Account.instance)

        // Verify user is logged into Dropbox
        if let client = Dropbox.authorizedClient {
            
            //Dropbox.unlinkClient()
            
            // Get the current user's account info
            client.usersGetCurrentAccount().response { response, error in
                if let account = response {
                    println("Hello \(account.name.givenName)")
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