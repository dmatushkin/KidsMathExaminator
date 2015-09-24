//
//  NSUserDefaultsExtension.swift
//  KidsMathExaminator
//
//  Created by Dmitry Matyushkin on 9/24/15.
//  Copyright © 2015 Dmitry Matyushkin. All rights reserved.
//

import UIKit

extension NSUserDefaults {

    class func getInt(key : String, defaultValue : Int) -> Int {
        if self.standardUserDefaults().objectForKey(key) == nil {
            return defaultValue
        } else {
            return self.standardUserDefaults().integerForKey(key)
        }
    }

    class func getBool(key : String, defaultValue : Bool) -> Bool {
        if self.standardUserDefaults().objectForKey(key) == nil {
            return defaultValue
        } else {
            return self.standardUserDefaults().boolForKey(key)
        }
    }

    class var operandMaximum : Int {
        get {
            return self.getInt("operandMaximum", defaultValue: 20)
        }
        set {
            self.standardUserDefaults().setInteger(newValue, forKey: "operandMaximum")
        }
    }

    class var tasksCount : Int {
        get {
            return self.getInt("tasksCount", defaultValue: 60)
        }
        set {
            self.standardUserDefaults().setInteger(newValue, forKey: "tasksCount")
        }
    }

    class var allowAddition : Bool {
        get {
            return self.getBool("allowAddition", defaultValue: true)
        }
        set {
            self.standardUserDefaults().setBool(newValue, forKey: "allowAddition")
        }
    }

    class var allowSubstraction : Bool {
        get {
            return self.getBool("allowSubstraction", defaultValue: true)
        }
        set {
            self.standardUserDefaults().setBool(newValue, forKey: "allowSubstraction")
        }
    }

    class var allowMultiplication : Bool {
        get {
        return self.getBool("allowMultiplication", defaultValue: false)
        }
        set {
            self.standardUserDefaults().setBool(newValue, forKey: "allowMultiplication")
        }
    }

    class var allowDivision : Bool {
        get {
        return self.getBool("allowDivision", defaultValue: false)
        }
        set {
            self.standardUserDefaults().setBool(newValue, forKey: "allowDivision")
        }
    }


}