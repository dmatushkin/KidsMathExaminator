//
//  ViewController.swift
//  KidsMathExaminator
//
//  Created by Dmitry Matyushkin on 9/22/15.
//  Copyright © 2015 Dmitry Matyushkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                let cell = tableView.dequeueCell(DisclosureCell.self, indexPath: indexPath)
                cell.titleLabel.text = "First operand"
                return cell
            } else {
                let cell = tableView.dequeueCell(DisclosureCell.self, indexPath: indexPath)
                cell.titleLabel.text = "Second operand"
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueCell(SwitchCell.self, indexPath: indexPath)
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueCell(SwitchCell.self, indexPath: indexPath)
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueCell(SwitchCell.self, indexPath: indexPath)
                return cell
            } else {
                let cell = tableView.dequeueCell(SwitchCell.self, indexPath: indexPath)
                return cell
            }
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "Operand limits"
        case 1: return "Allowed operators"
        default: return nil
        }
    }
}

