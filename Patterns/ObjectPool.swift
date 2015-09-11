//
//  ObjectPool.swift
//  Patterns
//
//  Created by David James on 9/4/15.
//  Copyright © 2015 Chaotic Moon. All rights reserved.
//

import Foundation

/*
      ___  _     _        _     ___          _
     / _ \| |__ (_)___ __| |_  | _ \___  ___| |
    | (_) | '_ \| / -_) _|  _| |  _/ _ \/ _ \ |
     \___/|_.__// \___\__|\__| |_| \___/\___/_|
              |__/

    D E F I N I T I O N
    • The object pool pattern manages a collection of reusable objects that are provided to calling components. 
    • A component obtains an object from the pool, uses it to perform work, and returns it to the pool so that it can be allocated to satisfy future requests. 
    • An object that has been allocated to a caller is not available for use by other components until it has been returned to the pool.

    B E N E F I T S
    • When many similar objects are needed or initialization is expensive, object pool pattern:
        • Reduces memory footprint
        • Optimizes initialization
        • Improves app performance
    • Object pool also encapsulates object construction.

    I M P L E M E N T A T I O N
    • 
    • Examples can be found in the PatternsExample project.

    T I P S   &   C A V E A T S
    • Cocoa tables and collection views use object pools for cell reuse.
    • Keep object pools as simple as possible and prefer safety over performance.
    • Make sure to test, test, test, in case concurrency is being used.

*/





