//
//  NumberSelectorCell.swift
//  KidsMathExaminator
//
//  Created by Dmitry Matyushkin on 9/23/15.
//  Copyright © 2015 Dmitry Matyushkin. All rights reserved.
//

import UIKit

class NumberSelectorCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueField: UITextField!

    var onValueUpdate : ((Int) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var valueNumber : Int? {
        get {
            return Int(valueField.text ?? "0")
        }
        set {
            if let val = newValue {
                if val < 0 {
                    valueField.text = "0"
                } else if val > 200 {
                    valueField.text = "200"
                } else {
                    valueField.text = "\(val)"
                }
            } else {
                valueField.text = "0"
            }
        }
    }

    func runHandler() {
        if let handler = onValueUpdate, number = self.valueNumber {
            handler(number)
        }
    }

    @IBAction func valueIncreaseAction(sender: AnyObject) {
        if let num = self.valueNumber {
            self.valueNumber = num + 10
        }
        runHandler()
    }

    @IBAction func valueDecreaseAction(sender: AnyObject) {
        if let num = self.valueNumber {
            self.valueNumber = num - 10
        }
        runHandler()
    }

    @IBAction func valueChangedAction(sender: AnyObject) {
        if let num = self.valueNumber {
            self.valueNumber = num
        } else {
            self.valueNumber = 0
        }
        runHandler()
    }
}
