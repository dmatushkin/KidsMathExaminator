//
//  UITableViewCellExtension.swift
//  KidsMathExaminator
//
//  Created by Dmitry Matyushkin on 9/23/15.
//  Copyright © 2015 Dmitry Matyushkin. All rights reserved.
//

import UIKit

extension UITableViewCell {
    class func identifier() -> String {
        return String(validatingUTF8: class_getName(self))!
    }
}
