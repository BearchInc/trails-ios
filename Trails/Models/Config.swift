import Foundation


class Config {
    enum Key: Int {
        case BaseUrl, Fabric
    }
    
    enum Paths: String {
        case Login = "/login"
        case RegisterDropbox = "/account/registerDropbox"
        case UpdateAccount = "/account/update"
        case NextEvaluation = "/account/trails/next_evaluation"
		case Stories = "/account/trails/stories"
    }
    
    private static let dev: [Key: String] = [
        .BaseUrl: "http://" + SERVER_IP + ":8080",
        .Fabric: ""
    ]
    
    private static let staging: [Key: String] = [
        .BaseUrl: "https://trails-dot-staging-api-getunseen.appspot.com",
        .Fabric: "staging-fabric"
    ]
    
    private static let appstore: [Key: String] = [
        .BaseUrl: "https://trails-dot-api-getunseen.appspot.com",
        .Fabric: "production-fabric"
    ]
    
    private static let configurations = [
        "dev": dev,
        "staging": staging,
        "appstore": appstore
    ]
    
    class func path(path: Paths) -> String {
        return get(Key.BaseUrl) + path.rawValue
    }
    
    class func path(path: String) -> String {
        return get(Key.BaseUrl) + path
    }
    
    class func get(key: Key) -> String {
        return configurations[FLAVOR]![key]!
    }
}
