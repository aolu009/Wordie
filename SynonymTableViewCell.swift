//
//  SynonymTableViewCell.swift
//  Wordie
//
//  Created by Lu Ao on 12/4/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

class SynonymTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var synonym: UILabel!
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clear
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
