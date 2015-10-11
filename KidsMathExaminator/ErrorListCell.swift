//
//  ErrorListCell.swift
//  KidsMathExaminator
//
//  Created by Dmitry Matyushkin on 10/11/15.
//  Copyright © 2015 Dmitry Matyushkin. All rights reserved.
//

import UIKit

class ErrorListCell: UITableViewCell {

    @IBOutlet weak var firstNumberLabel: UILabel!
    @IBOutlet weak var signLabel: UILabel!
    @IBOutlet weak var secondNumberLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!

    var firstNumber : Int = 0 {
        didSet {
            self.firstNumberLabel.text = "\(firstNumber)"
        }
    }

    var secondNumber : Int = 0 {
        didSet {
            self.secondNumberLabel.text = "\(secondNumber)"
        }
    }

    var sign : MathSign = MathSign.Plus {
        didSet {
            switch(sign) {
            case .Plus:
                self.signLabel.text = "+"
            case .Minus:
                self.signLabel.text = "-"
            case .Multiplication:
                self.signLabel.text = "*"
            case .Division:
                self.signLabel.text = "/"
            }
        }
    }

    var result : Int = 0 {
        didSet {
            self.resultLabel.text = "\(result)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
