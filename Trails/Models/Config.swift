import Foundation


class Config {
    enum Key: Int {
        case BaseUrl
    }
    
    enum Paths: String {
        case Login = "login"
        case RegisterDropbox = "account/registerDropbox"
        case UpdateAccount = "account/update"
    }

    class func path(path: Paths) -> String {
        return "http://" + SERVER_IP + ":8080/" + path.rawValue
    }
}
