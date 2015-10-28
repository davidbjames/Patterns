//
//  Worker.swift
//  Patterns
//
//  Created by David James on 10/28/15.
//  Copyright © 2015 Chaotic Moon. All rights reserved.
//

import Foundation

/*
    __      __       _
    \ \    / /__ _ _| |_____ _ _
     \ \/\/ / _ \ '_| / / -_) '_|
      \_/\_/\___/_| |_\_\___|_|

    D E F I N I T I O N
    • Encapsulate discrete units of work in "jobs" and allow "workers" to perform those jobs.

    B E N E F I T S
    • Keeps common or repeatable units of work encapsulated and hidden from the application.
    • Provides a consistent (and encapsulated) method for dispatching work.
    • Is "stateless" as each job should be passed or initialized with all the state it needs to perform the job.

    I M P L E M E N T A T I O N
    •

    T I P S   &   C A V E A T S
    • Similar to Command pattern or functional styles. 
    • More reasonable than functional in that it uses a composite type with a name and a clear purpose.
    • This pattern was "invented" by David James based on similar patterns such as the Thread Pool pattern.
*/

/*
          __     __
      __ / /__  / /
     / // / _ \/ _ \
     \___/\___/_.__/
*/

/**
    A unit of work.

    Holds the minimum state required to peform work.
    Generally implemented as a value type (struct or enum)
    Should have all state passed, have no knowledge outside of the job or how/when it is dispatched.
*/
public protocol Job {
    /// Optional Job state tracks things like done'ness and repeatability
    /// Implementation should make this a constant (let)
    var state:JobState? { get }
    /// Perform the work
    func perform()
}

/**
    Extension to Job

    Manages whether a job can be performed and tracks state.
*/
public extension Job {
    /// Can the job be performed (again)?
    var canPerform:Bool {
        get {
            if let state = state {
                if state.repeatable {
                    if let maxRepetitions = state.maxRepetitions {
                        return state.numTimesPerformed < maxRepetitions
                    } else {
                        return true // repeatable, no limit
                    }
                } else {
                    return state.numTimesPerformed < 1
                }
            } else {
                return true // no state object, always perform
            }
        }
    }
    /**
        Internal perform method wraps whether it's possible to perform + augments state.
        This extended method also serves to hide state manipulation from the Jobs themselves.
        
        - Parameter perform: closure containing the original Job's perform code.
    */
    func internalPerform(perform:()->Void) {
        if canPerform {
            perform()
            if let state = state {
                state.numTimesPerformed++
            }
        }
    }
}

/*
          __     __   ______       __
      __ / /__  / /  / __/ /____ _/ /____
     / // / _ \/ _ \_\ \/ __/ _ `/ __/ -_)
     \___/\___/_.__/___/\__/\_,_/\__/\__/
*/

/**
    Reusable Job State class

    If a Job needs JobState handling, specify it in the job's definition
*/
public class JobState {
    /// Determines if a job can be performed more than once
    var repeatable:Bool
    /// If repeatable, maximum number of times it can be repeated
    /// If not specified the job will be indefinitely repeatable.
    var maxRepetitions:Int?
    /// Number of times the job has been performed
    var numTimesPerformed:Int = 0
    /**
        Create a new JobState
        
        - Parameter repeatable: is job repeatable?
        - if this is false, subsequent calls to perform() are no-op
    */
    init(repeatable:Bool = false) {
        self.repeatable = repeatable
    }
    /**
        Create new JobState with specific max repititions
        
        - Parameter maxRepetitions: max number of performances
        - Parameter repeatable: is job repeatable?
    */
    convenience init(maxRepetitions:Int, repeatable:Bool = true) {
        self.init(repeatable: repeatable)
        self.maxRepetitions = maxRepetitions
    }
}

/*
      _      __         __
     | | /| / /__  ____/ /_____ ____
     | |/ |/ / _ \/ __/  '_/ -_) __/
     |__/|__/\___/_/ /_/\_\\__/_/

*/

/**
    Worker capable of doing one job at a time

    The worker is responsible for how a job is dispatched.
*/
public protocol Worker {
    /**
        Do work for a single job
    */
    func doWork(job: Job)
}

/**
    Worker extension provides a basic implementation.

    Use this vanilla implementation if the goal is solely to reap the benefits
    of encapsulation and better design without any need for custom dispatching.

    Provide your own overrides using dispatch or operation queues as necessary.
*/
public extension Worker {
    /**
        Do work for a single job on the current thread
        with no dispatch queues or operations.
    */
    func doWork(job: Job) {
        job.perform()
    }
}

/*
       ____                       ___      __         __
      / __ \__ _____ __ _____ ___/ / | /| / /__  ____/ /_____ ____
     / /_/ / // / -_) // / -_) _  /| |/ |/ / _ \/ __/  '_/ -_) __/
     \___\_\_,_/\__/\_,_/\__/\_,_/ |__/|__/\___/_/ /_/\_\\__/_/
*/

/**
    Worker capable of doing several jobs
*/
public protocol QueuedWorker {
    /// Array of Jobs
    var jobs:[Job] { get set }
    /**
        Add a job to the queue
    */
    mutating func addJob(job: Job)
    /**
        Do work for all jobs queued
    */
    func doWork()
}

/**
    Queued Worker extension provides a basic implementation.

    Use this vanilla implementation if the goal is solely to reap the benefits
    of encapsulation and better design without any need for custom dispatching.

    Provide your own overrides using dispatch or operation queues as necessary.
*/
public extension QueuedWorker {
    /**
        Add a job to the queue
    */
    mutating func addJob(job: Job) {
        jobs.append(job)
    }
    /**
        Do work for all jobs queued on the current thread
        with no dispatch queues or operations
    */
    func doWork() {
        for job in jobs {
            job.perform()
        }
    }
}

