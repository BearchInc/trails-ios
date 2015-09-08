import Foundation
import ObjectMapper
import CoreLocation

class Trail: Mappable {
    var trailType: TrailType!
    var likenessType: LikenessType!
    var createdAt: NSDate?
    var location: CLLocationCoordinate2D?
    
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
    
    class func newInstance(map: Map) -> Mappable? {
        
        var abc: CLLocationCoordinate2D? = CLLocationCoordinate2DMake(0.78, 0.78)
        return Trail()
    }
    
    
    func mapping(map: Map) {
        trailType <- (map["trail_type"], EnumTransform<TrailType>())
        likenessType <- (map["likness_type"], EnumTransform<LikenessType>())
        
    }
}
