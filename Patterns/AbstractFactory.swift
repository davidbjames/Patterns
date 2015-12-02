//
//  AbstractFactory.swift
//  Patterns
//
//  Created by David James on 11/23/15.
//  Copyright © 2015 Chaotic Moon. All rights reserved.
//

import Foundation

/*
       _   _       _               _     ___        _
      /_\ | |__ __| |_ _ _ __ _ __| |_  | __|_ _ __| |_ ___ _ _ _  _
     / _ \| '_ (_-<  _| '_/ _` / _|  _| | _/ _` / _|  _/ _ \ '_| || |
    /_/ \_\_.__/__/\__|_| \__,_\__|\__| |_|\__,_\__|\__\___/_|  \_, |
                                                                |__/

    D E F I N I T I O N
    • The abstract factory returns or uses the correct concrete factory for a family of related objects that conform to known interfaces. This allows the client to interact with the known interfaces without knowing which set of concrete objects it is using.

    B E N E F I T S
    •

    I M P L E M E N T A T I O N
    • There are generally 3 players in Abstract Factory pattern:
        1. The Abstract Factory with a static getFactory() method
        2. The Concrete Factories with create methods
        3. The Concrete Types returned by the Concrete Factories
    • Example: AbstractFactory.getFactory().createThing() returns concrete Thing

    T I P S   &   C A V E A T S
    • Watch for "switch" or "if/else" statements when deciding the correct abstract factory. This is generally a code smell, especially if the conditional logic exists within the application code. Normally the correct factory should be injected to components that need it.
    • Question: What is the key difference between Factory Method pattern and Abstract Factory pattern?
    • Answer: Factory Method uses inheritance -- indirection is vertical e.g. createThing(). Whereas, Abstract Factory uses composition -- indirection is horizontal e.g. getFactory().createThing().

*/