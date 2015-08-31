//: [Previous](@previous)

import Foundation
import Patterns
import Mantle

//
//     ___         _       _
//    | _ \_ _ ___| |_ ___| |_ _  _ _ __  ___
//    |  _/ '_/ _ \  _/ _ \  _| || | '_ \/ -_)
//    |_| |_| \___/\__\___/\__|\_, | .__/\___|
//                             |__/|_|
//

//
//     ___      ___          ____  ___           __       __
//    / _ \___ / _/__ ___ __/ / /_/ _ \_______  / /____  / /___ _____  ___
//   / // / -_) _/ _ `/ // / / __/ ___/ __/ _ \/ __/ _ \/ __/ // / _ \/ -_)
//  /____/\__/_/ \_,_/\_,_/_/\__/_/  /_/  \___/\__/\___/\__/\_, / .__/\__/
//                                                         /___/_/
//
// Example uses two classes to demonstrate deep cloning and the effect this has

class HttpRequest : DefaultPrototype {
    
    typealias Prototype = HttpRequest
    
    var auth: Authentication
    
    init(auth: Authentication) {
        self.auth = auth
    }
    
    // Required 3 methods to implement DefaultPrototype:
    
    required convenience init(clone: Prototype) {
        self.init(auth: clone.auth)
    }
    
    required convenience init(deepClone: Prototype) {
        let auth = Authentication(deepClone: deepClone.auth)
        self.init(auth: auth)
    }
    
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        // Override copy to use custom clone or deepClone method
        return Prototype(clone: self)
    }
}

class Authentication : NSObject, DefaultPrototype {
    
    typealias Prototype = Authentication

    var headers: [String:String]
    
    required init(headers: [String:String]) {
        self.headers = headers
    }
    
    required convenience init(clone: Prototype) {
        self.init(headers: clone.headers)
    }
    
    required convenience init(deepClone: Prototype) {
        // headers is a dictionary, which is a value type, so already copied
        self.init(headers: deepClone.headers)
    }
    
    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        // Override copy to use custom clone or deepClone method
        return Prototype(clone: self)
    }
    
}

//
//    --.--          |
//      |  ,---.,---.|--- ,---.
//      |  |---'`---.|    `---.
//      `  `---'`---'`---'`---'
//

let headers = ["If-None-Match" : "123"]
let auth = Authentication(headers: headers)
let request = HttpRequest(auth: auth)

let clonedRequest = HttpRequest(clone: request)
request.auth.headers["If-None-Match"] = "456"

// Proof #1
// Changing original request headers alters clone
clonedRequest.auth.headers

let deepClonedRequest = HttpRequest(deepClone: request)
request.auth.headers["If-None-Match"] = "789"

// Proof #2
// Changing original request headers does NOT alter "deep" clone
deepClonedRequest.auth.headers

//
//      ___       __       ___           __       __
//     / _ \___ _/ /____ _/ _ \_______  / /____  / /___ _____  ___
//    / // / _ `/ __/ _ `/ ___/ __/ _ \/ __/ _ \/ __/ // / _ \/ -_)
//   /____/\_,_/\__/\_,_/_/  /_/  \___/\__/\___/\__/\_, / .__/\__/
//                                                 /___/_/
//
// This is nearly identical to DefaultPrototype except:
//   a. it takes an optional data payload
//   b. (for this example), it extends Mantle model to be a more 
//      realistic implementation. Note, it does not implement
//      Mantle boilerplate, only the initializers.

class Message : MTLModel, DataPrototype {
   
    typealias Prototype = Message

    var sender: Sender!

    // Self
    // designated initializer
    init(sender: Sender) {
        self.sender = sender
        super.init()
    }
    
    // Self
    // convenience initializer
    convenience init(sender: Sender, dictionary dictionaryValue: [NSObject : AnyObject]!) throws {
        try self.init(dictionary: dictionaryValue)
        self.sender = sender
    }

    // MTLModel
    // inherited designated initializer
    override init!() { // <-- implicitly unwrapped failable initializer
        super.init()
    }

    // NSObjectProtocol
    // required designated initializer
    required init(coder: NSCoder) {
        // TODO: sender to be created here from coder or via Mantle integration
        super.init(coder: coder)
    }

    // MTLModelProtocol
    // required designated initializer
    required init(dictionary dictionaryValue: [NSObject : AnyObject]!) throws {
        try super.init(dictionary: dictionaryValue)
    }
    
    // DataPrototype
    required convenience init(clone: Prototype, data: Dictionary<NSObject, AnyObject>?) {
        
        let notClonedSender = clone.sender
        if let data = data {
            // TODO: handle error
            try! self.init(sender: notClonedSender, dictionary: data)
        } else {
            self.init(sender: notClonedSender)
        }
    }
    
    // DataPrototype
    required convenience init(deepClone: Prototype, data: Dictionary<NSObject, AnyObject>?) {
        
        let clonedSender = Sender(deepClone: deepClone.sender, data: data)
        if let data = data {
            data
            // extract other data to mutate this instance
            // Problem: dependency on keys in dictionary
        }
        // TODO: handle error
        try! self.init(sender: clonedSender, dictionary: data)
    }
}

class Sender : NSObject, DataPrototype {
    
    typealias Prototype = Sender
    
    var senderId : String!
    
    override init() {
        super.init()
    }
    
    required init(senderId: String) {
        self.senderId = senderId
        super.init()
    }

    required convenience init(clone: Prototype, data: Dictionary<NSObject, AnyObject>?) {
        if let data = data {
            // Problem: dependency on keys in dictionary
            if let senderId = data["senderId"] as? String {
                self.init(senderId: senderId)
                return
            }
        }
        self.init()
    }
    
    required convenience init(deepClone: Prototype, data: Dictionary<NSObject, AnyObject>?) {
        // No deep cloning for this example. See Message ^^
        self.init(clone: deepClone, data: data)
    }

    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        // Override copy to use custom clone or deepClone method
        return Prototype(clone: self, data: nil)
    }

}

//
//    --.--          |
//      |  ,---.,---.|--- ,---.
//      |  |---'`---.|    `---.
//      `  `---'`---'`---'`---'
//

// These tests are limited because it's not a full Mantle
// integration, so that key values are not setup.
let sender = Sender(senderId: "123")
let message = try Message(sender: sender, dictionary: [:])
let clonedMessage = Message(clone: message, data: [:])
sender.senderId = "456"
clonedMessage.sender.senderId
let deepClonedMessage = Message(deepClone: message, data: [:])
sender.senderId = "789"
// Proof: deep cloned sender is a new sender for the message
// NOTE: this is returning nil due to not implementing Mantle
deepClonedMessage.sender.senderId

//: [Next](@next)
