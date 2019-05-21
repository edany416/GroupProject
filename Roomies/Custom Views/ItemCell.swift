//
//  ItemCell.swift
//  Roomies
//
//  Created by edan yachdav on 5/12/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import UIKit

protocol ItemCellDelegate {
    func didTapCheckBox(for cell: ItemCell)
}

class ItemCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var addedBy: UILabel!
    @IBOutlet weak var checkBox: UIView!
    
    var delegate: ItemCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(checkBoxTapped))
        checkBox.addGestureRecognizer(gestureRecognizer)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc private func checkBoxTapped() {
        delegate?.didTapCheckBox(for: self)
    }
    
    

}
