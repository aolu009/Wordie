//
//  InputTableViewCell.swift
//  Wordie
//
//  Created by parry on 12/1/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit

class InputTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!

    private var resultBlock: ((_ changedText: String) -> ())? = nil

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.textField.delegate = self
        self.contentView.addSubview(self.textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(initalText: String, resultBlock: @escaping (_ changedText: String) -> ()) {
        self.textField.text = initalText
        self.resultBlock = resultBlock
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let block = self.resultBlock, let text = textField.text {
            block(text)
        }
    }
}
