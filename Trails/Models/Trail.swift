import Foundation
import ObjectMapper
import Alamofire

class Trail: Mappable {
    var trailType: TrailType!
    var likeness: LikenessType!
    var createdAt: NSDate!
    var mediaPath: String!
    var thumbExists: Bool!
    var mimeType: String!

    var likePath: String!
    var dislikePath: String!
    
    
    enum TrailType: Int {
        case PhotoTrail = 0
        case VideoTrail
        case AudioTrail
    }
    
    enum LikenessType: Int {
        case NotEvaluated = 0
        case LikedIt
        case DislikedIt
    }
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        trailType <- (map["trail_type"], EnumTransform<TrailType>())
        likeness <- (map["likeness"], EnumTransform<LikenessType>())
        createdAt <- (map["created_at"], TrailDateTransform())
        mediaPath <- map["media_path"]
        thumbExists <- map["thumb_exists"]
        mimeType <- map["mime_type"]
        
        likePath <- map["like_path"]
        dislikePath <- map["dislike_path"]
    }
    
    func didLikeItem() {
        ApiClient.request(.PATCH, path: likePath, params: nil)
    }
    
    func didDislikeItem() {
        ApiClient.request(.PATCH, path: dislikePath, params: nil)
    }
    
    class func nextEvaluation(completionHandler: ([Trail]?, ErrorType?) -> Void) {
        ApiClient.request(.GET, path: .NextEvaluation, params: nil).responseArray(completionHandler)
    }
}
