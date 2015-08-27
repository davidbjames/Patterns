//
//  Prototype.swift
//  GME
//
//  Created by David James on 8/25/15.
//  Copyright © 2015 Chaotic Moon. All rights reserved.
//

import Foundation
import Mantle

protocol Prototype : NSCopying, NSObjectProtocol {
    func clone() -> Self
    func deepClone() -> Self
}

protocol ModelPrototype : Prototype {
    func clone(dictionary: Dictionary<NSObject, AnyObject>?) -> Self?
    func deepClone(dictionary: Dictionary<NSObject, AnyObject>?) -> Self?
}

class ModelExample : MTLModel {
    
}

// Must be marked final so that Self requirements work correctly.
// See also http://stackoverflow.com/questions/25645090/protocol-func-returning-self

final class PrototypeExample : ModelExample, ModelPrototype { // Mantle model is NSObject + NSCopying
    
    override init() {
        super.init()
    }

    required init(dictionary dictionaryValue: [NSObject : AnyObject]!) throws {
        try super.init(dictionary: dictionaryValue)
    }
    
    // Prototype
    
    func clone() -> PrototypeExample {
        let clone = PrototypeExample.self()
        return clone
    }
    
    func deepClone() -> PrototypeExample {
        let clone = self.clone()
        // TODO: (deep)clone properties on self as necessary and re-add them to clone
        return clone
    }
    
    // ModelPrototype
    
    func clone(dictionary: Dictionary<NSObject, AnyObject>?) -> PrototypeExample? {
        
        if let dictionary = dictionary {
            if let clone = try? PrototypeExample.self(dictionary: dictionary) {
                // move add'l dictionary data to clone, although in this example
                // this would be handled by Mantle super class
                return clone
            } else {
                return nil
            }
        } else {
            return clone()
        }
    }
    
    func deepClone(dictionary: Dictionary<NSObject, AnyObject>?) -> PrototypeExample? {
        
        if let clone = clone(dictionary) {
            // TODO: (deep)clone properties on self as necessary and re-add them to clone
            return clone
        } else {
            return nil
        }
    }

    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        // Override copy to use custom clone or deepClone method
        return clone()
    }
    
}