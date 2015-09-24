//
//  SwitchCell.swift
//  KidsMathExaminator
//
//  Created by Dmitry Matyushkin on 9/23/15.
//  Copyright © 2015 Dmitry Matyushkin. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueSwitch: UISwitch!

    var onValueUpdate : ((Bool) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func valueChangedAction(sender: AnyObject) {
        if let handler = self.onValueUpdate {
            handler(self.valueSwitch.on)
        }
    }
}
