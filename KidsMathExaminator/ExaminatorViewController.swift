//
//  ExaminatorViewController.swift
//  KidsMathExaminator
//
//  Created by Dmitry Matyushkin on 9/22/15.
//  Copyright © 2015 Dmitry Matyushkin. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


enum MathSign {
    case plus
    case minus
    case multiplication
    case division

    func stringRepresentation() -> String {
        switch(self) {
        case .plus:
            return "+"
        case .minus:
            return "-"
        case .multiplication:
            return "*"
        case .division:
            return "/"
        }
    }

    func mathRepresentation() -> ((Int, Int) -> Int){
        switch(self) {
        case .plus:
            return (+)
        case .minus:
            return (-)
        case .multiplication:
            return (*)
        case .division:
            return (/)
        }
    }
}

class ExaminatorViewController: UIViewController {

    @IBOutlet weak var firstNumberLabel: UILabel!
    @IBOutlet weak var secondNumberLabel: UILabel!
    @IBOutlet weak var resultField: UITextField!
    @IBOutlet weak var signLabel: UILabel!
    @IBOutlet weak var currentExamLabel: UILabel!
    @IBOutlet weak var numberOfExamsLabel: UILabel!
    @IBOutlet weak var numberOfErrorsLabel: UILabel!
    @IBOutlet weak var equalsLabel: UILabel!

    let operandMax = UserDefaults.operandMaximum
    let numberOfExams = UserDefaults.tasksCount
    let operations : [MathSign] = {
        var result = [MathSign]()
        if UserDefaults.allowAddition {
            result.append(MathSign.plus)
        }
        if UserDefaults.allowSubstraction {
            result.append(MathSign.minus)
        }
        if UserDefaults.allowMultiplication {
            result.append(MathSign.multiplication)
        }
        if UserDefaults.allowDivision {
            result.append(MathSign.division)
        }
        return result
    }()

    let allOperations : [(Int, Int) -> (Int)] = [ (+) , (-) , (*) , (/) ]

    var errorOperations : [(x : Int, y : Int, op : MathSign, result : Int)] = []

    var currentExam = 1 {
        didSet {
            self.currentExamLabel.text = "\(self.currentExam)"
        }
    }

    var errorsNumber = 0 {
        didSet {
            self.numberOfErrorsLabel.text = "\(self.errorsNumber)"
            if errorsNumber > 0 {
                self.numberOfErrorsLabel.textColor = UIColor.red
            }
        }
    }

    var currentResult = 0
    var firstNumber : Int = 0 {
        didSet {
            firstNumberLabel.text = "\(firstNumber)"
        }
    }
    var secondNumber : Int = 0 {
        didSet {
            secondNumberLabel.text = "\(secondNumber)"
        }
    }
    var currentOperation : MathSign = MathSign.plus {
        didSet {
            self.signLabel.text = self.currentOperation.stringRepresentation()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBarHidden = true
        self.title = "Tasks"
        self.navigationItem.hidesBackButton = true
        self.numberOfExamsLabel.text = "\(self.numberOfExams)"
        getNextExam()
        self.resultField.becomeFirstResponder()
        if UIScreen.main.bounds.size.height == 480.0 {
            self.firstNumberLabel.font = UIFont.systemFont(ofSize: 30)
            self.secondNumberLabel.font = UIFont.systemFont(ofSize: 30)
            self.signLabel.font = UIFont.systemFont(ofSize: 30)
            self.equalsLabel.font = UIFont.systemFont(ofSize: 30)
            self.resultField.font = UIFont.systemFont(ofSize: 30)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    func flashInputWithColor(_ color : UIColor, clear : Bool) {
        UIView.animate(withDuration: 0.5, animations: { [weak self]() -> Void in
            self?.resultField.backgroundColor = color
            }, completion: { [weak self](success) -> Void in
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self?.resultField.backgroundColor = UIColor.white
                    }, completion: { [weak self] success in
                        if clear {
                            self?.resultField.text = ""
                        }
                })
        })
    }

    func flashSign() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.signLabel.alpha = 0.0;
            }, completion: { (success) -> Void in
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.signLabel.alpha = 1.0;
                })
        })
    }

    @IBAction func nextAction(_ sender: UIButton) {
        guard resultField.text?.characters.count > 0 else {
            return
        }
        if let result = Int(resultField.text!) {
            if result == currentResult {
                currentExam += 1
                flashInputWithColor(UIColor.green, clear: true)
                if (currentExam > self.numberOfExams) {
                    if let controller = self.storyboard?.instantiateViewController(withIdentifier: "ExamFinishedViewController") as? ExamFinishedViewController {
                        controller.tasksNumber = self.numberOfExams
                        controller.errorOperations = self.errorOperations
                        self.show(controller, sender: self)
                    }
                } else {
                    getNextExam()
                }
            } else {
                self.errorOperations.append((x: self.firstNumber, y : self.secondNumber, op: self.currentOperation, result: result))
                errorsNumber += 1
                flashInputWithColor(UIColor.red, clear: false)
                if verifyAllOperations(x: self.firstNumber, y: self.secondNumber, result: result) {
                    flashSign()
                }
            }
        }
        //self.resultField.text = ""
    }

    func verifyAllOperations( x : Int, y : Int, result : Int) -> Bool {
        for op in allOperations {
            if op(x, y) == result {
                return true
            }
        }
        return false
    }

    func setTaskConditions(x : Int, y : Int, sign : MathSign) {
        self.firstNumber = x
        self.secondNumber = y
        self.currentOperation = sign
        currentResult = sign.mathRepresentation()(x, y)
    }

    func getNextExam() {
        let sign = self.operations[Int(arc4random_uniform(UInt32(self.operations.count)))]
        var x = Int(arc4random_uniform(UInt32(operandMax))) + 1
        var y = Int(arc4random_uniform(UInt32(operandMax))) + 1
        if x < y && sign == MathSign.minus {
            let z = x
            x = y
            y = z
        }
        if sign == MathSign.division {
            x = x * y
        }
        setTaskConditions(x: x, y: y, sign: sign)
    }
}
