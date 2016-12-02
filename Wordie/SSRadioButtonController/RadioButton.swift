//
//  RadioButton.swift
//  Wordie
//
//  Created by Lu Ao on 11/30/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

class RadioButton: UIButton {
    
    override func awakeFromNib() {
        self.setImage(UIImage(named:"OnButton"), for: .normal)
        //self.layer.borderWidth = 2
        //self.layer.masksToBounds = true
        //self.layer.borderColor = UIColor.black.cgColor
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        toggleButton()
        super.touchesBegan(touches, with: event)
    }
    
    
    func toggleButton(){
        self.isSelected = !isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.setImage(#imageLiteral(resourceName: "OnButton"), for: .normal)
            } else {
                self.setImage(#imageLiteral(resourceName: "OffButton"), for: .normal)
            }
        }
    }
}
