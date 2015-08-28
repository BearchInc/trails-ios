import Foundation
import AlamofireObjectMapper
import Alamofire
import ObjectMapper

class Account : Mappable {
    var id: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var authToken: String!

    class func newInstance(map: Map) -> Mappable? {
        return Account()
    }

    func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        email <- map["email"]
        authToken <- map["auth_token"]
    }

    class func login(completionHandler: ([Account]?, NSError?) -> ()) {
        let loginParams = ["id": "MunjalTesting"]
        Alamofire.request(.POST, Config.loginPath(), parameters: loginParams, encoding: .JSON)
            .responseArray(completionHandler)
    }

}
