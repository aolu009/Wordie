//
//  WordTableViewCell.swift
//  Dictionary
//
//  Created by Lu Ao on 11/20/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit


class WordTableViewCell: UITableViewCell {

    @IBOutlet weak var word: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
}
