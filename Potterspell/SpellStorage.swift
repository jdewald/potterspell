//
//  SpellStorage.swift
//  Potterspell
//
//  Created by Joshua DeWald on 6/30/19.
//  Copyright © 2019 Joshua DeWald. All rights reserved.
//

import Foundation

import PennyPincher

@objc public class SpellStorage : NSObject {
    var spellTemplates = [PennyPincherTemplate]()
    var spellDefs: [String: [[[Double]]]] = [:]
    
    func saveSpells(targetUrl: URL) -> Bool {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self.spellDefs, options: JSONSerialization.WritingOptions.prettyPrinted)
                
            try jsonData.write(to: targetUrl)
                
            return true
        } catch  {
            print("Unexpected error: \(error).")
            return false
        }
        
        
    }
    
    func loadSpells(targetUrl: URL) -> Bool {
        do {
            let jsonData = NSData.init(contentsOf: targetUrl)!
            
            let loaded = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
            
            spellDefs = loaded as! [String : [[[Double]]]]
            
            for spellName in spellDefs.keys {
                for template in spellDefs[spellName]! {
                    spellTemplates.append(PennyPincher.createTemplate(spellName, points: template.map{ CGPoint(x:$0[0],y:$0[1]) })!)
                }
            }
            return true
        } catch {
            print("Unexpected error: \(error).")
            return false
        }
    }
    
    func addSpell(name: String, pixels:[CGPoint]) -> Bool {
        let template = PennyPincher.createTemplate(name, points:pixels)!
        
        var points = [[Double]]()
        
        for point in template.points {
            points.append([Double(point.x),Double(point.y)])
        }
        
        if spellDefs[name] == nil {
            spellDefs[name] = [points]
        } else {
            spellDefs[name] = spellDefs[name]! + [points]
        }
        
        self.spellTemplates.append(template)
        return true
    }
}
