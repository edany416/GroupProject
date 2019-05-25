//
//  ItemCell.swift
//  Roomies
//
//  Created by edan yachdav on 5/12/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import UIKit
import BEMCheckBox

protocol ItemCellDelegate {
    func didTapCheckBox(for cell: ItemCell)
}

class ItemCell: UITableViewCell, BEMCheckBoxDelegate {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var addedBy: UILabel!
    @IBOutlet weak var checkBox: BEMCheckBox!
    
    var delegate: ItemCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkBox.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func animationDidStop(for checkBox: BEMCheckBox) {
        delegate?.didTapCheckBox(for: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkBox.on = false
    }
    
}
