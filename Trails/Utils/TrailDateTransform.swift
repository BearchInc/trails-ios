import Foundation
import ObjectMapper

public class TrailDateTransform: DateFormaterTransform {
    
    public init() {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        super.init(dateFormatter: formatter)
    }
}