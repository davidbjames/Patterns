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

// (Base prototype for internal use only)
public protocol BasePrototype : NSCopying {
    // Define associated type. 
    // Implementations should define this at the top of the class e.g.:
    // typealias Prototype = MyPrototypeClass
    typealias Prototype
}

/*
Base prototype requires NSCopying for general compatibility 
with other libraries or integrations that requires copying.

Copy the following code snippet to implementation class:
- cannot add via extension due to @objc limitation. :/

    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        // Override copy to use custom clone or deepClone method
        return Prototype(clone: self)
    }
*/


//     ___      ___          ____  ___           __       __
//    / _ \___ / _/__ ___ __/ / /_/ _ \_______  / /____  / /___ _____  ___
//   / // / -_) _/ _ `/ // / / __/ ___/ __/ _ \/ __/ _ \/ __/ // / _ \/ -_)
//  /____/\__/_/ \_,_/\_,_/_/\__/_/  /_/  \___/\__/\___/\__/\_, / .__/\__/
//                                                         /___/_/

// Default prototype is the most basic type of prototype.
// Initializers can copy state and/or change state to default values.

// Pros: Basic out-of-box copying, with advantage of deep copying when needed.
// Cons: Little control over the state of the copied objects

public protocol DefaultPrototype : BasePrototype {
    // Copy over properties from prototype to new instance
    init(clone: Prototype)
    // Copy over properties and call clone/deepClone on properties that conform to *Prototype
    init(deepClone: Prototype)
}


//      ___       __       ___           __       __
//     / _ \___ _/ /____ _/ _ \_______  / /____  / /___ _____  ___
//    / // / _ `/ __/ _ `/ ___/ __/ _ \/ __/ _ \/ __/ // / _ \/ -_)
//   /____/\_,_/\__/\_,_/_/  /_/  \___/\__/\___/\__/\_, / .__/\__/
//                                                 /___/_/

// Data prototype supports adhoc data in the form of key value pairs.
// Initializers can populate state on copies based on this data.

// Pros: Provides more control over mutation of clones. Plays nicely
// with model frameworks like Mantle which handle state restoration
// based on predefined property names.
// Cons: Creates a dependency between calling code and instances on
// the properties/keys and values required to create state.

public protocol DataPrototype : BasePrototype, NSObjectProtocol {
    // Copy over properties from prototype to new instance
    init(clone: Prototype, data: Dictionary<NSObject, AnyObject>?)
    // Copy over properties and call clone/deepClone on properties that conform to *Prototype
    init(deepClone: Prototype, data: Dictionary<NSObject, AnyObject>?)
}

// Interpreted prototype. Conceptual. The idea is to use an "interpreter"
// to map adhoc data to properties.
//public protocol InterpreterPrototype


// See the following SO article on gotchas related to using Self in protocols
// http://stackoverflow.com/questions/25645090/protocol-func-returning-self

