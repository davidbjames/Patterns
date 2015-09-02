//
//  Singleton.swift
//  Patterns
//
//  Created by David James on 9/2/15.
//  Copyright © 2015 Chaotic Moon. All rights reserved.
//

import Foundation

class Testola {
    
}
class SingletonA {
    
    static let sharedInstance = SingletonA()
    
    private init() {
        print("AAA");
    }
    
}

public protocol TestProtocol {
    
}
// TODO: Create simple logger class if it makes sense