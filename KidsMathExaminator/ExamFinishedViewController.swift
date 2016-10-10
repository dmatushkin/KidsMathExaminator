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
    @IBOutlet weak var viewErrorsButton: UIButton!

    var tasksNumber = 0

    var errorOperations : [(x : Int, y : Int, op : MathSign, result : Int)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "You've done"
        self.navigationItem.hidesBackButton = true
        self.tasksPassedLabel.text = "\(self.tasksNumber)"
        self.errorsLabel.text = "\(self.errorOperations.count)"
        if self.errorOperations.count > 0 {
            self.errorsLabel.textColor = UIColor.red
        } else {
            self.viewErrorsButton.isHidden = true
        }
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ErrorsListViewController {
            vc.errorOperations = self.errorOperations
        }
    }

}
