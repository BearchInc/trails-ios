import Foundation
import ObjectMapper

enum AuthorizationType {
	case Web
	case Dropbox
}

class Story: Mappable {
	var title: String!
	var imagePath: String!
	var likenessCount: Int!
	var authorizationType: AuthorizationType!
	var selfPath: String!
	
	required init?(_ map: Map) {
	}
	
	func mapping(map: Map) {
		title <- map["title"]
		imagePath <- map["image_path"]
		likenessCount <- map["likeness_count"]
		authorizationType <- map["authorization_type"]
		selfPath <- map["self_path"]
	}
	
	func fetchTrails(completionHandler: ([Trail]?, ErrorType?) -> Void) {
		ApiClient.request(.GET, path: selfPath, params: nil).responseArray(completionHandler)
	}
	
	class func fetchStories(completionHandler: ([Story]?, ErrorType?) -> Void) {
		ApiClient.request(.GET, path: .Stories, params: nil).responseArray(completionHandler)
	}
}
