//
//  OverviewTableCell.swift
//  Invoice
//
//  Created by Wilhelm Thieme on 05/05/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import UIKit

class OverviewTableCell: UITableViewCell {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    
    
    var title: String? { didSet { titleLabel.text = title } }
    var date: String? { didSet { dateLabel.text = date } }
    var amount: String? { didSet { amountLabel.text = amount } }
    
}
