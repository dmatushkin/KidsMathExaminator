//
//  NSUserDefaultsExtension.swift
//  KidsMathExaminator
//
//  Created by Dmitry Matyushkin on 9/24/15.
//  Copyright © 2015 Dmitry Matyushkin. All rights reserved.
//

import UIKit

extension UserDefaults {

    class func getInt(_ key : String, defaultValue : Int) -> Int {
        if self.standard.object(forKey: key) == nil {
            return defaultValue
        } else {
            return self.standard.integer(forKey: key)
        }
    }

    class func getBool(_ key : String, defaultValue : Bool) -> Bool {
        if self.standard.object(forKey: key) == nil {
            return defaultValue
        } else {
            return self.standard.bool(forKey: key)
        }
    }

    class var operandMaximum : Int {
        get {
            return self.getInt("operandMaximum", defaultValue: 20)
        }
        set {
            self.standard.set(newValue, forKey: "operandMaximum")
        }
    }

    class var tasksCount : Int {
        get {
            return self.getInt("tasksCount", defaultValue: 60)
        }
        set {
            self.standard.set(newValue, forKey: "tasksCount")
        }
    }

    class var allowAddition : Bool {
        get {
            return self.getBool("allowAddition", defaultValue: true)
        }
        set {
            self.standard.set(newValue, forKey: "allowAddition")
        }
    }

    class var allowSubstraction : Bool {
        get {
            return self.getBool("allowSubstraction", defaultValue: true)
        }
        set {
            self.standard.set(newValue, forKey: "allowSubstraction")
        }
    }

    class var allowMultiplication : Bool {
        get {
        return self.getBool("allowMultiplication", defaultValue: false)
        }
        set {
            self.standard.set(newValue, forKey: "allowMultiplication")
        }
    }

    class var allowDivision : Bool {
        get {
        return self.getBool("allowDivision", defaultValue: false)
        }
        set {
            self.standard.set(newValue, forKey: "allowDivision")
        }
    }


}
