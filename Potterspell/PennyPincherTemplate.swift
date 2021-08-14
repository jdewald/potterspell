import Foundation

 @objc public class PennyPincherTemplate : NSObject {
    public var id: String
    public var points = [CGPoint]()
    
    public init(id: String, points: [CGPoint]) {
        self.id = id;
        self.points = points;
    }
}

