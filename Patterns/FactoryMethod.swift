//
//  Factory.swift
//  Patterns
//
//  Created by David James on 10/27/15.
//  Copyright © 2015 Chaotic Moon. All rights reserved.
//

import Foundation

/*
     ___        _                  __  __     _   _            _
    | __|_ _ __| |_ ___ _ _ _  _  |  \/  |___| |_| |_  ___  __| |
    | _/ _` / _|  _/ _ \ '_| || | | |\/| / -_)  _| ' \/ _ \/ _` |
    |_|\__,_\__|\__\___/_|  \_, | |_|  |_\___|\__|_||_\___/\__,_|
                            |__/
    
    D E F I N I T I O N
    • The factory method selects and returns a concrete implementation that satisfies a known interface without the client knowing how the decision was made or what concrete class was used.

    B E N E F I T S
    • Keeps client-supplier relationships loosely coupled and knowledge of public interfaces to a minimum.
    • Simplifies creational logic for many sub-types by consolidating it in a single method.

    I M P L E M E N T A T I O N
    • The three main types of Factory Method pattern:
      1. "Static wrapper" uses a simple class or struct with a static method to create the desired object. It takes context parameters to support "decision logic".
      2. "Static hierarchy" uses a class hierarchy with static methods where the parent class defers actual creation to child sub-classes that create their own type and initialize. It takes context parameters to support "decision logic".
      3. "Pure factory" uses an abstract class with abstract methods that return the correct sub-types for the parent class to use. There are no static methods in this pattern and generally no "decision logic".

    T I P S   &   C A V E A T S
    • "Class clusters" is similar to Factory Method -- concrete classes are hidden and clients work only with a common interface.
    • General rule for "static method" approaches: the client should have no knowledge of which implementation it wants. I.e. the parameters passed to the Factory Method should not imply knowledge of the concrete type that is returned. For example, imagine a factory that returns a synchronous or asynchronous dispatch queue via method called dispatchFactory. Using a call such as dispatchFactory("async") would be poor design, because the parameter implies that the client knows what kind of dispatch queue it needs i.e. asynchronous. Deciding this is the factory's job. The parameter should provide only the "context" by which the factory method can make a logical decision. Keep clients type agnostic.

*/

/*
       ____         __
      / __/__ _____/ /____  ______ __
     / _// _ `/ __/ __/ _ \/ __/ // /
    /_/  \_,_/\__/\__/\___/_/  \_, /
                              /___/
*/
public protocol Factory {
    // For future compatibility, do not use. Use sub-types instead.
}

/*
       ______       __  _     ____         __
      / __/ /____ _/ /_(_)___/ __/__ _____/ /____  ______ __
     _\ \/ __/ _ `/ __/ / __/ _// _ `/ __/ __/ _ \/ __/ // /
    /___/\__/\_,_/\__/_/\__/_/  \_,_/\__/\__/\___/_/  \_, /
                                                     /___/

*/

/**
    A static factory uses only static or class methods and supports either
    a "static wrapper" (one struct / method) or a "static hierarchy" of factories, 
    Use the hiearchy approach if sub types have specific initialization requirements
    OR if those sub types have their own sub-types which must be handled.
*/
public protocol StaticFactory : Factory {
    /// Some context object / tuple that provides the factory with 
    /// enough information to make a decision without being explicit.
    /// See also "general rule" above.
    typealias FactoryContext
    /// Some known interface
    typealias KnownInterface
    /// Single create method which returns the known interface
    static func create(context: FactoryContext) -> KnownInterface?
}

/*
       ___               ____         __
      / _ \__ _________ / __/__ _____/ /____  ______ __
     / ___/ // / __/ -_) _// _ `/ __/ __/ _ \/ __/ // /
    /_/   \_,_/_/  \__/_/  \_,_/\__/\__/\___/_/  \_, /
                                                /___/

*/

/**
    A pure factory uses non-static methods to return sub-types required
    by the current type. This is the traditional Factory Method.

    There is no interface to this as it returns specific sub-types known
    to the factory class, e.g. createFile, createDirectory.
    For semantic purposes only.
*/
public protocol PureFactory : Factory {
    
}

/**
    Context object or tuple that enables the factory to make a decision
    as to what concrete type to return.
 
    Empty interface. Used for semantic purposes only.
*/
public protocol FactoryContext {
    
}
