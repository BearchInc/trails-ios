import Foundation
import AlamofireObjectMapper
import Alamofire
import ObjectMapper
import SwiftyDropbox

class Account : Mappable {
    var id: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var authToken: String!

    static let instance = Account()

    class func newInstance(map: Map) -> Mappable? {
        return instance
    }

    func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        email <- map["email"]
        authToken <- map["auth_token"]
    }

    class func login(completionHandler: (Account?, NSError?) -> ()) {
        let loginParams = ["id": "MunjalTesting"]
        Alamofire.request(.POST, Config.path(.Login), parameters: loginParams, encoding: .JSON)
            .responseObject(completionHandler)
    }

    func update(dropboxAccount: Users.FullAccount) {
        firstName = dropboxAccount.name.givenName
        lastName = dropboxAccount.name.surname
        email = dropboxAccount.email
        
        let accountParams = Mapper().toJSON(self)
        ApiClient.request(.POST, path: .UpdateAccount, params: accountParams).response {
            (_, response: NSHTTPURLResponse?, _, error) -> Void in
            if (response?.statusCode >= 400) {
                println("You are fucked - cannot update account")
            }
        }
    }
    
    func registerDropbox(userId: String, accessToken: String) {
        ApiClient.request(.POST, path: .RegisterDropbox, params: ["user_id": userId, "access_token": accessToken]).response {
        (_, response: NSHTTPURLResponse?, _, error) -> Void in
            if (response?.statusCode >= 400) {
                println("You are fucked - cannot register dropbox")
            }
        }
    }

}
