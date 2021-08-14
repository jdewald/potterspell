import Foundation

// This is an adaptation of https://github.com/fe9lix/PennyPincher 

@objc public class PennyPincherResult : NSObject {
    public var template: PennyPincherTemplate?
    public var similarity: CGFloat = 0.0
    
    init(template: PennyPincherTemplate, similarity: CGFloat) {
        self.template = template;
        self.similarity = similarity;
    }
}

@objc open class PennyPincher : NSObject {
    fileprivate static let NumResamplingPoints = 16
    
    @objc open class func createTemplate(_ id: String, points: [CGPoint]) -> PennyPincherTemplate? {
        guard points.count > 0 else { return nil }
        
        return PennyPincherTemplate(id: id, points: PennyPincher.resampleBetweenPoints(points))
    }
    
    @objc open class func recognize(_ points: [CGPoint], templates: [PennyPincherTemplate]) -> PennyPincherResult? {
        guard points.count > 0 && templates.count > 0 else { return nil }
        
        let c = PennyPincher.resampleBetweenPoints(points)
        
        guard c.count > 0 else { return nil }
        
        var similarity = CGFloat.leastNormalMagnitude
        var t: PennyPincherTemplate!
        var d: CGFloat
        
        for template in templates {
            d = 0.0
            
            let count = min(c.count, template.points.count)
            
            for i in 0...count - 1 {
                let tp = template.points[i]
                let cp = c[i]
                
                d = d + tp.x * cp.x + tp.y * cp.y
                
                if d > similarity {
                    similarity = d
                    t = template
                }
            }
        }
        
        guard t != nil else { return nil }
        
        return PennyPincherResult(template: t, similarity: similarity)
    }
    
    fileprivate class func resampleBetweenPoints(_ p: [CGPoint]) -> [CGPoint] {
        var points = p
        let i = pathLength(points) / CGFloat(PennyPincher.NumResamplingPoints - 1)
        var d: CGFloat = 0.0
        var v = [CGPoint]()
        var prev = points.first!
        var index = 0
        
        for _ in points {
            if index == 0 {
                index += 1
                continue
            }
            
            let thisPoint = points[index]
            let prevPoint = points[index - 1]
            
            let pd = distanceBetween(thisPoint, to: prevPoint)
            
            if (d + pd) >= i {
                let q = CGPoint(
                    x: prevPoint.x + (thisPoint.x - prevPoint.x) * (i - d) / pd,
                    y: prevPoint.y + (thisPoint.y - prevPoint.y) * (i - d) / pd
                )
                
                var r = CGPoint(x: q.x - prev.x, y: q.y - prev.y)
                let rd = distanceBetween(CGPoint.zero, to: r)
                r.x = r.x / rd
                r.y = r.y / rd
                
                d = 0.0
                prev = q
                
                v.append(r)
                points.insert(q, at: index)
                index += 1
            } else {
                d = d + pd
            }
            
            index += 1
        }
        
        return v
    }
    
    fileprivate class func pathLength(_ points: [CGPoint]) -> CGFloat {
        var d: CGFloat = 0.0
        
        for i in 1..<points.count {
            d = d + distanceBetween(points[i - 1], to: points[i])
        }
        
        return d
    }
    
    fileprivate class func distanceBetween(_ pointA: CGPoint, to pointB: CGPoint) -> CGFloat {
        let distX = pointA.x - pointB.x
        let distY = pointA.y - pointB.y
        
        return sqrt((distX * distX) + (distY * distY))
    }
}
