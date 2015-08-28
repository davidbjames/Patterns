//
//  Prototype.swift
//  GME
//
//  Created by David James on 8/25/15.
//  Copyright © 2015 Chaotic Moon. All rights reserved.
//

import Foundation

//
//     ___         _       _
//    | _ \_ _ ___| |_ ___| |_ _  _ _ __  ___
//    |  _/ '_/ _ \  _/ _ \  _| || | '_ \/ -_)
//    |_| |_| \___/\__\___/\__|\_, | .__/\___|
//                             |__/|_|
//

// Default prototype is the most basic type of prototype.
// Initializers can copy state and/or change state to default values.

// Pros: Basic out-of-box copying, with advantage of deep copying when needed.
// Cons: Little control over the state of the copied objects

public protocol DefaultPrototype : NSCopying {
    init(clone: Self)
    init(deepClone: Self)
}

// Data prototype supports adhoc data in the form of key value pairs.
// Initializers can populate state on copies based on this data.

// Pros: Provides more control over mutation of clones. Plays nicely
// with model frameworks like Mantle which handle state restoration
// based on predefined property names.
// Cons: Creates a dependency between calling code and instances on
// the properties/keys and values required to create state.

public protocol DataPrototype : NSCopying, NSObjectProtocol {
    init(clone: Self, data: Dictionary<NSObject, AnyObject>?)
    init(deepClone: Self, data: Dictionary<NSObject, AnyObject>?)
}

// Interpreted prototype. Conceptual. The idea is to use an "interpreter"
// to map adhoc data to properties.
//public protocol InterpreterPrototype


// See the following SO article on gotchas related to using Self in protocols
// http://stackoverflow.com/questions/25645090/protocol-func-returning-self



//     required init(dictionary dictionaryValue: [NSObject : AnyObject]!) throws {
//try super.init(dictionary: dictionaryValue)
//}
