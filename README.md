![ViewQuery](./web/PatternsProjectBanner1.png) 

Patterns Project
================

What is it?
-----------

The Patterns Project is a repository for *pattern protocols*. 

*Pattern protocols* are interfaces that describe the semantics of design patterns. 

In plain English ➡️ **Help developers learn and implement design patterns by simply conforming to protocols**. 

Why do this?
------------

Typically, design patterns are implicitly defined in code, which makes it hard to know *what* pattern is being used or *if* a pattern is being used at all! This is not helpful to communicating intent in programs, and has been an impediment to learning design patterns, for decades. 

The Patterns Project attempts to overcome this shortcoming by simply **making design patterns explicitly named** via *pattern protocols*. 

Instead of design patterns remaining obscure, they become obvious, to implementers and maintainers. 

Examples
--------

Let's show a few patterns, and see how they become obvious for: 

* the *implementer* because the methods are described in the protocol 
* the *maintainer* because the class/struct is named according to the pattern.

*** 

#### Prototype Pattern

##### Protocol:

Here's a *pattern protocol*. It's just a Swift protocol with some required methods.

~~~Swift
public protocol Prototype : NSCopying, NSObjectProtocol {
    /// Copy over properties from prototype to new instance
    init(clone: Self)
    /// Copy over properties and call clone/deepClone on properties that conform to *Prototype*
    init(deepClone: Self)
}
~~~

##### Implementation:

Implementing is easier than falling off a bicycle. You just implement the required methods.

~~~Swift
class HttpRequest : NSObject, Prototype { 

    var auth: Authentication // each request requires authentication

    init(auth: Authentication) {
        self.auth = auth
    }

    // Required 3 methods to implement Prototype:

    required convenience init(clone: HttpRequest) {
        self.init(auth: clone.auth)
    }

    required convenience init(deepClone: HttpRequest) {
        // For deep clone create a new instance of the 
        // associated Authentication object and call it's deepClone 
        // initializer so it can further clone downwards.
        let auth = Authentication(deepClone: deepClone.auth)
        self.init(auth: auth)
    }

    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        // Override copy to use custom clone or deepClone method
        return HttpRequest(clone: self)
    }
    
    // .. code for handling request
}
~~~

##### Client Code:

...and *now*, the client code simple consumes that interface. The implementer is not kept in the dark. They know they're dealing with the **Prototype** pattern.

~~~Swift
let headers = ["If-None-Match" : "123"]
let auth = Authentication(headers: headers)

let request1 = HttpRequest(auth: auth)

let request2 = HttpRequest(clone: request1) // << cloning here

// change the Etag on request 2
request2.auth.headers["If-None-Match"] = "456"

// Do something with the requests
~~~

Admittedly, this is not the greatest example, but you get the idea. 

***

#### Worker Pattern

Here's another example using the **Worker** pattern:

##### Protocol:

~~~Swift
public protocol Job {
    /// Perform the work
    func perform()
}

public protocol Worker {
    /// Do work for a single job
    func doWork(job: Job)
}
~~~

##### Implementation:

~~~Swift
struct MyJob : Job {
    func perform() {
        // .. do something useful ..
    }
}

struct MyWorker : Worker {
    func doWork(job: Job) {
        job.perform()
    }
}
~~~

##### Client code:

~~~Swift
MyWorker().doWork(MyJob())
~~~

Again, a contrived example, but hopefully the idea is sinking in. 🙂

> NOTE: There is no **Worker** pattern in the original Go4 design patterns. That's OK! The Patterns Project is totally open ended. Yes, we want to cover the original patterns, but we also want to update those patterns to work better with modern language paradigms *and* to create brand new patterns along the way.

***

#### Object Pool Pattern

One more example. Something a little more powerful. 

##### Protocol:

~~~Swift
public protocol ObjectPool {
    /// Generic type. Can be any type (not only objects). Use ObjectPoolItem as necessary.
    associatedtype Resource
    /// Check out a resource from the pool if one is available.
    /// This is usually blocking (sync) but doesn't have to be.
    func checkoutResource() -> Resource?
    
    /// Return a resource back to the pool.
    /// This is usually non-blocking (async).
    func checkin(resource: Resource)
    
    /// Process all resources currently in the pool.
    /// Be aware the pool may change from what is passed to this method,
    /// if this method is called asynchronously.
    func processPool(callback: [Resource] -> Void)
}

public protocol ObjectPoolItem {
    /// Reset object state so it can be reused
    func prepareForReuse()
}
~~~

##### Implementation:

~~~Swift
public class DefaultPool<Resource> : ObjectPool {

    /// Core array of resources. Always private. Use protocol methods to access.
    private var resources:[Resource]

    /// Initialize empty pool
    public init() {
        self.resources = []
    }

    /// Initialize with initial resources (eager method)
    public convenience init(resources: [Resource]) {
        self.init()
        self.resources = resources
    }

    /// Check out a resource from the pool if one is available.
    public func checkoutResource() -> Resource? {
        return isEmpty() ? nil : resources.removeAtIndex(0)
    }

    /// Check a resource back into the pool.
    public func checkin(resource: Resource) {

        // Allow objects to prepare for reuse.
        if resource is ObjectPoolItem {
            (resource as! ObjectPoolItem).prepareForReuse()
        }
        resources.append(resource)
    }

    /// Process all resources currently in the pool.
    public func processPool(callback: [Resource] -> Void) {
        callback(self.resources)
    }
}
~~~

(The project includes "eager" and "lazy" variations on this that use background threads and semaphores, but we'll keep it simple for now.)

##### Client Code:

Notice how we can combine patterns: **Object Pool** + **Prototype**

~~~Swift
class Tool : NSObject, ObjectPoolItem, AnonymousPrototype {

    enum ToolType : String {
        case Hammer = "Hammer"
        case ScrewDriver = "Screw Driver"
        case File = "File"
    }

    typealias Prototype = Tool

    var type:ToolType
    var numberCheckouts:Int = 0

    init(type: ToolType) {
        self.type = type
    }

    // ObjectPoolItem

    func prepareForReuse() {
        // prepare prototype for re-use
        // reset state etc
    }

    // AnonymousPrototype

    func clone() -> AnonymousPrototype {
        return Tool(type: self.type)
    }

    func deepClone() -> AnonymousPrototype {
        return Tool(type: self.type)
    }
}

// Mock rental store that has *eager loaded* **Object Pools** of available tools for rental.

class ToolRentalStore {

    let hammerPool: EagerPool<Tool>
    let screwdriverPool: EagerPool<Tool>
    let filePool: EagerPool<Tool>

    init() {
        // Build a fake tool store with a limited number of each tool
        
        ...

        // Initialize the object pools
        
        ...
    }

    func rentTool(type: Tool.ToolType) -> Tool? {
        if let tool = poolByType(type).checkoutResource() {
            tool.numberCheckouts++
            return tool
        } else {
            return nil
        }
    }

    func returnTool(tool: Tool) {
        poolByType(tool.type).checkin(tool)
    }

    func poolByType(type: Tool.ToolType) -> EagerPool<Tool> {
        switch type {
        case .Hammer :
            return hammerPool
        case .ScrewDriver :
            return screwdriverPool
        case .File :
            return filePool
        }
    }
}

// Tests:

let dispatchGroup = dispatch_group_create()
let store = ToolRentalStore()

for i in 1 ... 35 { // 35 rentals
    dispatch_group_async(dispatchGroup, toolQueue, { () -> Void in
    
        // 1. Pick a random tool
        let types:[Tool.ToolType] = [.Hammer, .ScrewDriver, .File]
        let type = types[(0...2).random] as Tool.ToolType

        // 2. Rent the tool from the store -- *if* it's available
        if let tool = store.rentTool(type) {

            // 3. Create some random sleeps to make sure the order these are fired is random
            //    in order to test concurrent handling.
            NSThread.sleepForTimeInterval(Double((0...1).random))
            
            // 4. Now (after sleep period (or not)) return tool back to store.
            store.returnTool(tool)
        } else {
            // Tool was not available for rent (within the max wait time)
            print("Failed to rent \(type.rawValue)")
        }
    })
}

dispatch_group_wait(dispatchGroup, DISPATCH_TIME_FOREVER)
~~~