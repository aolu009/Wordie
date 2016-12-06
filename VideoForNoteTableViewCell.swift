//
//  VideoForNoteTableViewCell.swift
//  Wordie
//
//  Created by Lu Ao on 12/5/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

class VideoForNoteTableViewCell: UITableViewCell {

    
    @IBOutlet weak var videoPreview: UIImageView!
    @IBOutlet weak var videoSentence: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
