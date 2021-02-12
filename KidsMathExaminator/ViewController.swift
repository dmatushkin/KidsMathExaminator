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
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardNotification(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bottomLayoutConstraint.constant = 8.0
    }

    @objc func keyboardNotification(_ notification: Notification) {
        if let userInfo = (notification as NSNotification).userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions().rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            
            UIView.animate(withDuration: duration,
                delay: TimeInterval(0),
                options: animationCurve,
                animations: {[weak self] in
                    self?.bottomLayoutConstraint.constant = (endFrame?.size.height ?? 0.0) + 8.0
                    self?.view.layoutIfNeeded()
                },
                completion: nil)
        }
    }

    func updateRunButton() {
        self.runButton.isEnabled = (UserDefaults.allowAddition || UserDefaults.allowDivision || UserDefaults.allowMultiplication || UserDefaults.allowSubstraction) && UserDefaults.operandMaximum > 0 && UserDefaults.tasksCount > 0
        self.runButton.backgroundColor = self.runButton.isEnabled ? UIColor.green : UIColor.lightGray
    }

    @IBAction func unwindToSettings(_ segue: UIStoryboardSegue) {
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return 2
        case 1: return 4
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            if (indexPath as NSIndexPath).row == 0 {
                let cell = tableView.dequeueCell(NumberSelectorCell.self, indexPath: indexPath)
                cell.titleLabel.text = NSLocalizedString("Operand maximum", comment: "Maximum value for operand")
                cell.valueNumber = UserDefaults.operandMaximum
                cell.onValueUpdate = { [unowned self] in
                    UserDefaults.operandMaximum = $0
                    self.updateRunButton()
                }
                return cell
            } else {
                let cell = tableView.dequeueCell(NumberSelectorCell.self, indexPath: indexPath)
                cell.titleLabel.text = NSLocalizedString("Number of tasks", comment: "Number of calculation tasks")
                cell.valueNumber = UserDefaults.tasksCount
                cell.onValueUpdate = { [unowned self] in
                    UserDefaults.tasksCount = $0
                    self.updateRunButton()
                }
                return cell
            }
        } else {
            if (indexPath as NSIndexPath).row == 0 {
                let cell = tableView.dequeueCell(SwitchCell.self, indexPath: indexPath)
                cell.titleLabel.text = NSLocalizedString("Allow addition", comment: "Are addition operation tasks allowed")
                cell.valueSwitch.isOn = UserDefaults.allowAddition
                cell.onValueUpdate = { [unowned self] in
                    UserDefaults.allowAddition = $0
                    self.updateRunButton()
                }
                return cell
            } else if (indexPath as NSIndexPath).row == 1 {
                let cell = tableView.dequeueCell(SwitchCell.self, indexPath: indexPath)
                cell.titleLabel.text = NSLocalizedString("Allow substraction", comment: "Are substraction operation tasks allowed")
                cell.valueSwitch.isOn = UserDefaults.allowSubstraction
                cell.onValueUpdate = { [unowned self] in
                    UserDefaults.allowSubstraction = $0
                    self.updateRunButton()
                }
                return cell
            } else if (indexPath as NSIndexPath).row == 2 {
                let cell = tableView.dequeueCell(SwitchCell.self, indexPath: indexPath)
                cell.titleLabel.text = NSLocalizedString("Allow multiplication", comment: "Are multiplication operation tasks allowed")
                cell.valueSwitch.isOn = UserDefaults.allowMultiplication
                cell.onValueUpdate = { [unowned self] in
                    UserDefaults.allowMultiplication = $0
                    self.updateRunButton()
                }
                return cell
            } else {
                let cell = tableView.dequeueCell(SwitchCell.self, indexPath: indexPath)
                cell.titleLabel.text = NSLocalizedString("Allow division", comment: "Are division operation tasks allowed")
                cell.valueSwitch.isOn = UserDefaults.allowDivision
                cell.onValueUpdate = { [unowned self] in
                    UserDefaults.allowDivision = $0
                    self.updateRunButton()
                }
                return cell
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return NSLocalizedString("Limits", comment: "Limits section title")
        case 1: return NSLocalizedString("Allowed operators", comment: "Operations section title")
        default: return nil
        }
    }
}

