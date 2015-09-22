import Foundation
import ObjectMapper

class Story: Mappable {
	var imagePath: String!
	var title: String!
	var trails: [Trail]!
	
	required init?(_ map: Map) {
	}
	
	func mapping(map: Map) {
		imagePath <- map["image_path"]
		title <- map["title"]
		trails <- map["trails"]
	}
	
	class func fetchStories(completionHandler: ([Story]?, ErrorType?) -> Void) {
		ApiClient.request(.GET, path: .Stories, params: nil).responseArray(completionHandler)
	}
}
