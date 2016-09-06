//
// Copyright Noel Cower 2014.
// Adapted for Swift 2 and improved by David James
// Distributed under the Boost Software License, Version 1.0.
// http://www.boost.org/LICENSE_1_0.txt
//

import Foundation

precedencegroup Additive {
    associativity : left
}

/// Asynchronous WorkQueue scheduling operator.
infix operator >- : Additive

/// Synchronous WorkQueue scheduling operator.
infix operator >+ : Additive

/// Asynchronous with barrier WorkQueue scheduling operator.
infix operator >|- : Additive

/// Synchronous with barrier WorkQueue scheduling operator.
infix operator >|+ : Additive


/// Exception thrown when attempting to schedule a barrier block on a queue
/// that does not accept barrier blocks (i.e., NSOperatonQueue).
let QBarrierUnsupportedException = "QBarrierUnsupportedException"


/// Enumeration for Cocoa/Dispatch work queues. Wraps dispatch queues and
/// NSOperationQueue instances. Both permit scheduling of synchronous and
/// asynchronous execution of blocks, while dispatch queues also permit
/// scheduling barrier blocks as well.
///
/// A third case, the .Immediate queue, is for forcing execution of blocks
/// onto the calling thread to be performed immediately.
public enum WorkQueue {

    public typealias Work = () -> Void

    // ------------------------------------
    // Member values :
    
    
    /// WorkQueue for a dispatch_queue_t
    case dispatchQueue(Dispatch.DispatchQueue)

    /// WorkQueue for an NSOperationQueue
    case operationQueue(Foundation.OperationQueue)

    /// WorkQueue for the same thread of execution (just calls the block given
    /// for both sync and async).
    case immediate(Thread)

    
    // ------------------------------------
    // Convenience factories for different
    // types of queues and operations
    
    
    /// Gets the current thread of execution
    public static var ImmediateDispatch: WorkQueue {
        get {
            return immediate(Thread.current)
        }
    }
    
    
    /// Gets the main thread's dispatch queue.
    public static var MainDispatch: WorkQueue {
        get {
            return dispatchQueue(DispatchQueue.main)
        }
    }

    
    /// Gets the main thread's NSOperationQueue.
    public static var MainOps: WorkQueue {
        get {
            return operationQueue(Foundation.OperationQueue.main)
        }
    }
    
    
    /// Gets the default priority global dispatch queue.
    public static var DefaultPriority: WorkQueue {
        get {
            let queue = DispatchQueue.global(qos: .default)
            return dispatchQueue(queue)
        }
    }


    /// Gets the background priority global dispatch queue.
    public static var Background: WorkQueue {
        get {
            let queue = DispatchQueue.global(qos: .background)
            return dispatchQueue(queue)
        }
    }
    
    
    /*
     
    // TODO: map these to appropriate quality of service classes

    /// Gets the high priority global dispatch queue.
    public static var HighPriority: WorkQueue {
        get {
            let queue = DispatchQueue.global(qos: .default)
            return dispatchQueue(queue)
        }
    }

    /// Gets the low priority global dispatch queue.
    public static var LowPriority: WorkQueue {
        get {
            let queue = DispatchQueue.global(qos: .default)
            return dispatchQueue(queue)
        }
    }

    */

    /// Attempts to get the current NSOperationQueue and return it as a
    /// WorkQueue. Returns nothing if unsuccessful.
    public static var CurrentOps: WorkQueue? {
        get {
            if let queue = Foundation.OperationQueue.current {
                return operationQueue(queue)
            } else {
                return nil
            }
        }
    }
    
    
    // ------------------------------------
    // Parameterized factories for standard
    // dispatch queues (background and serial)

    /// Allocates a new background dispatch queue with the given name.
    public static func backgroundDispatchQueue(_ named: String) -> WorkQueue {
        return dispatchQueue(DispatchQueue(label: named, qos: .background))
    }


    /// Allocates a new serial dispatch queue with the given name.
    public static func serialDispatchQueue(_ named: String) -> WorkQueue {
        return dispatchQueue(DispatchQueue(label: named)) // .default
    }
    

    // ------------------------------------
    // Public methods for firing a block of work
    // async/sync with or without barriers

    
    /// Schedules the given block asynchronously on the WorkQueue. This is your
    /// fire-and-forget work.
    func async(_ block: Work) {
        switch (self) {
        case .immediate(_):
            block()

        case let .dispatchQueue(queue):
            queue.async(execute: block)

        case let .operationQueue(queue):
            queue.addOperation(block)
        }
    }


    /// Schedules the given block on the WorkQueue and attempts to wait until
    /// the block has run and finished.
    ///
    /// Be warned that attempting to run a synchronous task on a queue that you
    /// are already on will potentially deadlock or worse. Where possible,
    /// avoid synchronous tasks altogether or do not schedule them on the same
    /// queue currently executing the task.
    func sync(_ block: Work) {
        switch (self) {
        case .immediate(_):
            block()

        case let .dispatchQueue(queue):
            queue.sync(execute: block)

        case let .operationQueue(queue):
            let blockOp = BlockOperation(block: block)
            queue.addOperation(blockOp)
            blockOp.waitUntilFinished()
        }
    }


    /// Schedules an async block on the given queue with a barrier to ensure
    /// other blocks do not execute concurrently.
    ///
    /// Only supported on dispatch queues. Attempting to schedule a barrier
    /// block on an NSOperationQueue will raise an exception because the
    /// operation is impossible and doing anything else could potentially
    /// compromise the program's state.
    ///
    /// Immediate queues continue to execute blocks
    /// immediately on the calling thread (i.e., same as just calling the block
    /// yourself).
    func asyncWithBarrier(_ block: Work) {
        switch (self) {
        case .immediate(_):
            // Would throw an exception for this as well, but this is already
            // sort of a barrier and mostly for the sake of debugging
            // (i.e., the chance of Immediate being useful in normal contexts
            // is really low).
            block()

        case let .dispatchQueue(queue):
            queue.async(flags: .barrier, execute: block)

        case .operationQueue(_):
            NSException(
                name: NSExceptionName(rawValue: QBarrierUnsupportedException),
                reason: "Async barrier operations are unsupported for NSOperationQueue",
                userInfo: nil
                ).raise()
        }
    }


    /// Schedules a sync block on the given queue with a barrier to ensure
    /// other blocks do not execute concurrently. Does not return until
    /// the block has finished executing.
    ///
    /// Only supported on dispatch queues. Attempting to schedule a barrier
    /// block on an NSOperationQueue will raise an exception because the
    /// operation is impossible and doing anything else could potentially
    /// compromise the program's state.
    ///
    /// Immediate queues continue to execute blocks immediately on the calling
    /// thread (i.e., same as just calling the block yourself).
    func syncWithBarrier(_ block: Work) {
        switch (self) {
        case .immediate(_):
            block()

        case let .dispatchQueue(queue):
            queue.sync(flags: .barrier, execute: block)

        case .operationQueue(_):
            NSException(
                name: NSExceptionName(rawValue: QBarrierUnsupportedException),
                reason: "Sync barrier operations are unsupported for NSOperationQueue",
                userInfo: nil
                ).raise()
        }
    }


    /// Runs the given block on the main thread asynchronously. This is
    /// short-hand for requesting the main dispatch thread and calling its
    /// async method.
    static func runOnMain(_ block: Work) {
        MainDispatch.async(block)
    }
    
    

}


/** 
Check if dispatch queues are the same queue or for closures that are immediately executed if they share the same thread. 
Note: 
- Dispatch queue labels have no meaning beyond debugging
- Therefore, all calls to dispatch_queue_create make a new instance (a new queue) regardless if the label is shared.
- Queues that should be shared and reused need to be stored or passed as parameters. When doing this, be careful though to avoid memory leaks.
Author: David James
*/
public func === (left: WorkQueue, right: WorkQueue) -> Bool {
    
    var leftQueue:DispatchQueue?
    var rightQueue:DispatchQueue?
    var leftThread:Thread?
    var rightThread:Thread?
    
    // Gather up left and right dispatch queues, if they exist.
    // For Immediate dispatches, check if they are on main thread.
    
    switch (left) {
    case .dispatchQueue(let queue) :
        leftQueue = queue
    case .operationQueue(let queue) :
        if let underlyingQueue = queue.underlyingQueue {
            leftQueue = underlyingQueue
        }
    case .immediate(let thread) :
        leftThread = thread
    }
    
    switch (right) {
    case .dispatchQueue(let queue) :
        rightQueue = queue
    case .operationQueue(let queue) :
        if let underlyingQueue = queue.underlyingQueue {
            rightQueue = underlyingQueue
        }
    case .immediate(let thread) :
        rightThread = thread
    }
    
    // Check if left and right dispatch queues are exactly equal,
    // or baring that (for immediate dispatches) check if both threads are the same.
    // (Understand that immediate is not as useful, both in use and comparison.)
    
    if let leftQueue = leftQueue, let rightQueue = rightQueue {
        return leftQueue === rightQueue
    } else {
        if let leftThread = leftThread, let rightThread = rightThread {
            return leftThread === rightThread
        } else {
            return false
        }
    }
}


/// Short-hand operator for scheduling a block for asynchronous execution on a
/// WorkQueue.
///
/// Returns the queue to permit chaining.
@discardableResult public func >- (queue: WorkQueue, block: WorkQueue.Work) -> WorkQueue {
    queue.async(block)
    return queue
}


/// Short-hand operator for scheduling a block for synchronous execution on a
/// WorkQueue (i.e., this will not return until the block has finished).
///
/// Returns the queue to permit chaining.
@discardableResult public func >+ (queue: WorkQueue, block: WorkQueue.Work) -> WorkQueue {
    queue.sync(block)
    return queue
}


/// Short-hand operator for scheduling a block for asynchronous execution with
/// a barrier on a WorkQueue.
///
/// Returns the queue to permit chaining.
@discardableResult public func >|- (queue: WorkQueue, block: WorkQueue.Work) -> WorkQueue {
    queue.asyncWithBarrier(block)
    return queue
}


/// Short-hand operator for scheduling a block for synchronous execution with a
/// barrier on a WorkQueue (i.e., this will not return until the block has
/// finished).
///
/// Returns the queue to permit chaining.
@discardableResult public func >|+ (queue: WorkQueue, block: WorkQueue.Work) -> WorkQueue {
    queue.syncWithBarrier(block)
    return queue
}
