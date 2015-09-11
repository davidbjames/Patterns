//
//  Singleton.swift
//  Patterns
//
//  Created by David James on 9/2/15.
//  Copyright © 2015 Chaotic Moon. All rights reserved.
//

import Foundation

/*
     ___ _           _     _
    / __(_)_ _  __ _| |___| |_ ___ _ _
    \__ \ | ' \/ _` | / -_)  _/ _ \ ' \
    |___/_|_||_\__, |_\___|\__\___/_||_|
               |___/

    D E F I N I T I O N
    • The singleton pattern ensures that only one object of a given type exists in the application

    B E N E F I T S
    • Encapsulates shared and global resources (such as logging, analytics or app preferences) that should be handled consistently throughout the app.
    • Mimics a resource (such as a server, printer or current device) that could not exist apart from it's real-world counterpart.

    I M P L E M E N T A T I O N
    • Conform to the Singleton protocol even though it doesn't do anything right now.
    • Examples can be found in the PatternsExample project.

    T I P S   &   C A V E A T S
    • Keep singletons thread-safe so that they can be used efficiently.
    • Singletons should not be copyable.
    • Do not use singletons to pass global state. One exception to this may be user preferences, but these should be read only and potentially abstracted into a service layer.

*/


public protocol Singleton {

}
