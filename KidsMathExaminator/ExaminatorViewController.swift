//
//  ExaminatorViewController.swift
//  KidsMathExaminator
//
//  Created by Dmitry Matyushkin on 9/22/15.
//  Copyright © 2015 Dmitry Matyushkin. All rights reserved.
//

import UIKit

enum MathSign {
    case Plus
    case Minus
    case Multiplication
    case Division

    func stringRepresentation() -> String {
        switch(self) {
        case .Plus:
            return "+"
        case .Minus:
            return "-"
        case .Multiplication:
            return "*"
        case .Division:
            return "/"
        }
    }

    func mathRepresentation() -> ((Int, Int) -> Int){
        switch(self) {
        case .Plus:
            return (+)
        case .Minus:
            return (-)
        case .Multiplication:
            return (*)
        case .Division:
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

    let operandMax = NSUserDefaults.operandMaximum
    let numberOfExams = NSUserDefaults.tasksCount
    let operations : [MathSign] = {
        var result = [MathSign]()
        if NSUserDefaults.allowAddition {
            result.append(MathSign.Plus)
        }
        if NSUserDefaults.allowSubstraction {
            result.append(MathSign.Minus)
        }
        if NSUserDefaults.allowMultiplication {
            result.append(MathSign.Multiplication)
        }
        if NSUserDefaults.allowDivision {
            result.append(MathSign.Division)
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
                self.numberOfErrorsLabel.textColor = UIColor.redColor()
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
    var currentOperation : MathSign = MathSign.Plus {
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
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }

    func flashInputWithColor(color : UIColor) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.resultField.backgroundColor = color
            }, completion: { (success) -> Void in
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.resultField.backgroundColor = UIColor.whiteColor()
                })
        })
    }

    func flashSign() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.signLabel.alpha = 0.0;
            }, completion: { (success) -> Void in
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.signLabel.alpha = 1.0;
                })
        })
    }

    @IBAction func nextAction(sender: UIButton) {
        guard resultField.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 else {
            return
        }
        if let result = Int(resultField.text!) {
            if result == currentResult {
                currentExam++
                flashInputWithColor(UIColor.greenColor())
                if (currentExam > self.numberOfExams) {
                    if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ExamFinishedViewController") as? ExamFinishedViewController {
                        controller.tasksNumber = self.numberOfExams
                        controller.errorOperations = self.errorOperations
                        self.showViewController(controller, sender: self)
                    }
                } else {
                    getNextExam()
                }
            } else {
                self.errorOperations.append((x: self.firstNumber, y : self.secondNumber, op: self.currentOperation, result: result))
                errorsNumber++
                flashInputWithColor(UIColor.redColor())
                if verifyAllOperations(x: self.firstNumber, y: self.secondNumber, result: result) {
                    flashSign()
                }
            }
        }
        //self.resultField.text = ""
    }

    func verifyAllOperations( x x : Int, y : Int, result : Int) -> Bool {
        for op in allOperations {
            if op(x, y) == result {
                return true
            }
        }
        return false
    }

    func setTaskConditions(x x : Int, y : Int, sign : MathSign) {
        self.firstNumber = x
        self.secondNumber = y
        self.currentOperation = sign
        currentResult = sign.mathRepresentation()(x, y)
    }

    func getNextExam() {
        self.resultField.text = ""
        let sign = self.operations[Int(arc4random_uniform(UInt32(self.operations.count)))]
        var x = Int(arc4random_uniform(UInt32(operandMax))) + 1
        var y = Int(arc4random_uniform(UInt32(operandMax))) + 1
        if x < y && sign == MathSign.Minus {
            let z = x
            x = y
            y = z
        }
        if sign == MathSign.Division {
            x = x * y
        }
        setTaskConditions(x: x, y: y, sign: sign)
    }
}
