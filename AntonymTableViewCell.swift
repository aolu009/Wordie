//
//  AntonymTableViewCell.swift
//  Wordie
//
//  Created by Lu Ao on 12/4/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

class AntonymTableViewCell: UITableViewCell {

    @IBOutlet weak var antonym: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
