//
//  TableViewCell.swift
//  DemoAppLocation
//
//  Created by $hivang on 06/09/16.
//  Copyright © 2016 Adiosft. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    
    @IBOutlet var lblMeter: UILabel!
    @IBOutlet var lblDay: UILabel!
    @IBOutlet var lblnymber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
