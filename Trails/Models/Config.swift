import Foundation

class Config {
    class func loginPath() -> String {
        return "http://" + SERVER_IP + ":8080/login"
    }
}
