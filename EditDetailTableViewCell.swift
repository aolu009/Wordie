//
//  EditDetailTableViewCell.swift
//  Wordie
//
//  Created by Lu Ao on 11/30/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import Firebase
@objc protocol EditDetailTableViewCellDelegate{
    func editDetailTableViewCellGiveIdxNMessage(indexPath:IndexPath,text:String, selected:Bool)
}


class EditDetailTableViewCell: UITableViewCell,UITextViewDelegate {

    @IBOutlet weak var detailEditField: UITextView!
    @IBOutlet weak var radioButton: RadioButton!
    var delegate: EditDetailTableViewCellDelegate?
    var textArray: [String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.detailEditField.delegate = self
        self.radioButton.isSelected = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func textViewDidChange(_ textView: UITextView) {
        //print(self.in)
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let cell: EditDetailTableViewCell = textView.superview!.superview as! EditDetailTableViewCell
        let table = cell.superview?.superview as! UITableView
        let textFieldIndexPath = table.indexPath(for: cell)
        self.delegate?.editDetailTableViewCellGiveIdxNMessage(indexPath: textFieldIndexPath!, text: self.detailEditField.text, selected: self.radioButton.isSelected)
        
    }
    @IBAction func onButtonPressed(_ sender: Any) {
        //let cell: EditDetailTableViewCell = self.superview!.superview as! EditDetailTableViewCell
        let table = self.superview?.superview as! UITableView
        let textFieldIndexPath = table.indexPath(for: self)
        self.delegate?.editDetailTableViewCellGiveIdxNMessage(indexPath: textFieldIndexPath!, text: self.detailEditField.text, selected: self.radioButton.isSelected)
    }
    
   

}
