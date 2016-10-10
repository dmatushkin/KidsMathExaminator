//
//  ErrorsListViewController.swift
//  KidsMathExaminator
//
//  Created by Dmitry Matyushkin on 10/11/15.
//  Copyright © 2015 Dmitry Matyushkin. All rights reserved.
//

import UIKit

class ErrorsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var errorOperations : [(x : Int, y : Int, op : MathSign, result : Int)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.title = "Mistakes"
    }



    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }


    // MARK: - table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.errorOperations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ErrorListCell.self, indexPath: indexPath)
        let errorTask = self.errorOperations[(indexPath as NSIndexPath).row]
        cell.firstNumber = errorTask.x
        cell.secondNumber = errorTask.y
        cell.sign = errorTask.op
        cell.result = errorTask.result
        return cell
    }
}
