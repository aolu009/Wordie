//
//  DefinitionTableViewCell.swift
//  Dictionary
//
//  Created by Lu Ao on 11/20/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

class DefinitionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var definitionText: UILabel!
    @IBOutlet weak var exampleText: UILabel!
    @IBOutlet weak var categoryText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
