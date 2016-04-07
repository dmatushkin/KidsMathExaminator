//
//  ViewController.swift
//  KidsMathExaminator
//
//  Created by Dmitry Matyushkin on 9/22/15.
//  Copyright © 2015 Dmitry Matyushkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var runButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateRunButton()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardNotification(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.bottomLayoutConstraint.constant = 8.0
    }

    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            UIView.animateWithDuration(duration,
                delay: NSTimeInterval(0),
                options: animationCurve,
                animations: {[weak self] in
                    self?.bottomLayoutConstraint.constant = (endFrame?.size.height ?? 0.0) + 8.0
                    self?.view.layoutIfNeeded()
                },
                completion: nil)
        }
    }

    func updateRunButton() {
        self.runButton.enabled = (NSUserDefaults.allowAddition || NSUserDefaults.allowDivision || NSUserDefaults.allowMultiplication || NSUserDefaults.allowSubstraction) && NSUserDefaults.operandMaximum > 0 && NSUserDefaults.tasksCount > 0
        self.runButton.backgroundColor = self.runButton.enabled ? UIColor.greenColor() : UIColor.lightGrayColor()
    }

    @IBAction func unwindToSettings(segue: UIStoryboardSegue) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return 2
        case 1: return 4
        default: return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueCell(NumberSelectorCell.self, indexPath: indexPath)
                cell.titleLabel.text = "Operand maximum"
                cell.valueNumber = NSUserDefaults.operandMaximum
                cell.onValueUpdate = { [unowned self] in
                    NSUserDefaults.operandMaximum = $0
                    self.updateRunButton()
                }
                return cell
            } else {
                let cell = tableView.dequeueCell(NumberSelectorCell.self, indexPath: indexPath)
                cell.titleLabel.text = "Number of tasks"
                cell.valueNumber = NSUserDefaults.tasksCount
                cell.onValueUpdate = { [unowned self] in
                    NSUserDefaults.tasksCount = $0
                    self.updateRunButton()
                }
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueCell(SwitchCell.self, indexPath: indexPath)
                cell.titleLabel.text = "Allow addition"
                cell.valueSwitch.on = NSUserDefaults.allowAddition
                cell.onValueUpdate = { [unowned self] in
                    NSUserDefaults.allowAddition = $0
                    self.updateRunButton()
                }
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueCell(SwitchCell.self, indexPath: indexPath)
                cell.titleLabel.text = "Allow substraction"
                cell.valueSwitch.on = NSUserDefaults.allowSubstraction
                cell.onValueUpdate = { [unowned self] in
                    NSUserDefaults.allowSubstraction = $0
                    self.updateRunButton()
                }
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueCell(SwitchCell.self, indexPath: indexPath)
                cell.titleLabel.text = "Allow multiplication"
                cell.valueSwitch.on = NSUserDefaults.allowMultiplication
                cell.onValueUpdate = { [unowned self] in
                    NSUserDefaults.allowMultiplication = $0
                    self.updateRunButton()
                }
                return cell
            } else {
                let cell = tableView.dequeueCell(SwitchCell.self, indexPath: indexPath)
                cell.titleLabel.text = "Allow division"
                cell.valueSwitch.on = NSUserDefaults.allowDivision
                cell.onValueUpdate = { [unowned self] in
                    NSUserDefaults.allowDivision = $0
                    self.updateRunButton()
                }
                return cell
            }
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "Limits"
        case 1: return "Allowed operators"
        default: return nil
        }
    }
}

