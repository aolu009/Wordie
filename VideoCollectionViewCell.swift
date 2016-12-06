//
//  VideoCollectionViewCell.swift
//  Wordie
//
//  Created by parry on 12/3/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var placeholderImageView: UIImageView!
    
    var url: URL?
 
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.contentView.layer.cornerRadius = 2
        self.contentView.layer.masksToBounds = false
    }
    
    
}
