//
//  ExamFinishedViewController.swift
//  KidsMathExaminator
//
//  Created by Dmitry Matyushkin on 9/23/15.
//  Copyright © 2015 Dmitry Matyushkin. All rights reserved.
//

import UIKit

class ExamFinishedViewController: UIViewController {

    @IBOutlet weak var tasksPassedLabel: UILabel!
    @IBOutlet weak var errorsLabel: UILabel!

    var tasksNumber = 0
    var errorsNumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tasksPassedLabel.text = "\(self.tasksNumber)"
        self.errorsLabel.text = "\(self.errorsNumber)"
        if self.errorsNumber > 0 {
            self.errorsLabel.textColor = UIColor.redColor()
        }
        self.navigationController?.navigationBarHidden = true
    }


    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }

}
