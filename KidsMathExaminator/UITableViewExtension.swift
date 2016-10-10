//
//  UITableViewExtension.swift
//  KidsMathExaminator
//
//  Created by Dmitry Matyushkin on 9/23/15.
//  Copyright © 2015 Dmitry Matyushkin. All rights reserved.
//

import UIKit

extension UITableView {

    fileprivate func cellIdentifier<T:UITableViewCell>(_ cell : T.Type) -> String {
        return String(validatingUTF8: class_getName(T))!
    }

    func registerCell<T:UITableViewCell>(_ cell : T.Type) {
        self.register(T.self, forCellReuseIdentifier: self.cellIdentifier(T))
    }

    func dequeueCell<T:UITableViewCell>(_ cell : T.Type, indexPath : IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: self.cellIdentifier(T), for: indexPath) as! T
    }
}
