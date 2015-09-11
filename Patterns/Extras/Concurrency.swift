//
//  Concurrency.swift
//  Patterns
//
//  Created by David James on 9/4/15.
//  Copyright © 2015 Chaotic Moon. All rights reserved.
//

import Foundation

/// Some function of work.

/// Holds the minimum state required to peform work.
/// Generally implemented as a struct or enum.
/// Jobs should not know about the app at large or how the work should be dispatched (concurrency).

public protocol Job {
    func perform()
}

/// Worker capable of doing Jobs.

/// Workers are responsible for constructing job state and controlling how a job is dispatched.

public protocol Worker {
    func doWork(job: Job)
}

public extension Worker {
    // vanilla implementation
    func doWork(job: Job) {
        job.perform()
    }
}