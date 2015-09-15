import Foundation
import Alamofire

class ApiClient {
    
    class func request(method: Alamofire.Method, path: Config.Paths, params: [String: AnyObject]?) -> Request {
        return request(method, path: path.rawValue, params: params)
    }
    
    class func request(method: Alamofire.Method, path: String, params: [String: AnyObject]?) -> Request {
        setAuthHeaders()
        let urlPath = Config.path(path)
        return Alamofire.request(method, urlPath, parameters: params, encoding: .JSON, headers: setAuthHeaders())
    }

    
    private class func setAuthHeaders() -> [String : String]?{
        let plainString = "\(Account.instance.authToken):" as NSString
        print("Auth string: \(plainString)")
        let plainData = plainString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))

        return ["Authorization": "Basic " + base64String!]
    }
}