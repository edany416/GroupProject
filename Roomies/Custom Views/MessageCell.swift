//
//  MessageCell.swift
//  Roomies
//
//  Created by Louise on 5/22/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import UIKit

protocol MessageCellDelegate {
    
}

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var sentBy: UILabel!
    @IBOutlet weak var message: UILabel!
    
    var delegate: MessageCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
