import Foundation
import AlamofireObjectMapper
import Alamofire
import ObjectMapper
import SwiftyDropbox
import AdSupport
import SSKeychain

class Account : Mappable {
    let KEYCHAIN_SERVICE_NAME = "com.bearch.Hashtag"
    let KEYCHAIN_ACCOUNT_ID_KEY = "HashtagAccountId"
    let USER_DEFAULTS_ACCOUNT_KEY = "HashtagAccountKey"
    
    var id: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var authToken: String!

    static var instance = Account()

    class func newInstance(map: Map) -> Mappable? {
        return instance
    }
    
    init() {
        self.id = ""
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.authToken = ""
    }
    
    required init?(_ map: Map){
        Account.instance = self
    }

    func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        email <- map["email"]
        authToken <- map["auth_token"]
    }

    func login(completionHandler: (Account?, ErrorType?) -> Void) {
        let loginParams = ["id": retrieveAccountId()]
        
        Alamofire.request(.POST, Config.path(.Login), parameters: loginParams, encoding: .JSON).responseObject(completionHandler)
    }
    
    private func retrieveAccountId() -> String {
        var accountId = retrieveAccountIdFromKeychain()
        if accountId == nil {
            accountId = createAccountId()
        }
        return accountId!
    }

    private func retrieveAccountIdFromKeychain() -> String? {
        return SSKeychain.passwordForService(NSBundle.mainBundle().bundleIdentifier, account: KEYCHAIN_ACCOUNT_ID_KEY)
    }
    
    private func createAccountId() -> String {
        let accountId = ASIdentifierManager.sharedManager().advertisingIdentifier.UUIDString
        SSKeychain.setPassword(accountId, forService: NSBundle.mainBundle().bundleIdentifier, account: KEYCHAIN_ACCOUNT_ID_KEY)
        return accountId
    }


    func update(dropboxAccount: Users.FullAccount) {
        firstName = dropboxAccount.name.givenName
        lastName = dropboxAccount.name.surname
        email = dropboxAccount.email
        
        let accountParams = Mapper().toJSON(self)
        ApiClient.request(.POST, path: .UpdateAccount, params: accountParams).response {
            (_, response: NSHTTPURLResponse?, _, error) -> Void in
            if (response?.statusCode >= 400) {
                print("Unable to update the account")
            }
        }
    }
    
    func registerDropbox(userId: String, accessToken: String) {
        ApiClient.request(.POST, path: .RegisterDropbox, params: ["user_id": userId, "access_token": accessToken]).response {
        (_, response: NSHTTPURLResponse?, _, error) -> Void in
            if (response?.statusCode >= 400) {
                print("Unable to register dropbox")
            }
        }
    }

}
