//
//  UITableViewExtension.swift
//  KidsMathExaminator
//
//  Created by Dmitry Matyushkin on 9/23/15.
//  Copyright © 2015 Dmitry Matyushkin. All rights reserved.
//

import UIKit

extension UITableView {

    private func cellIdentifier<T:UITableViewCell>(cell : T.Type) -> String {
        return String(UTF8String: class_getName(T))!
    }

    func registerCell<T:UITableViewCell>(cell : T.Type) {
        self.registerClass(T.self, forCellReuseIdentifier: self.cellIdentifier(T))
    }

    func dequeueCell<T:UITableViewCell>(cell : T.Type, indexPath : NSIndexPath) -> T {
        return self.dequeueReusableCellWithIdentifier(self.cellIdentifier(T), forIndexPath: indexPath) as! T
    }
}