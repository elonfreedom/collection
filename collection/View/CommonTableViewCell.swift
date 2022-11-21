//
//  CommonTableViewCell.swift
//  collection
//
//  Created by 张晖 on 2022/3/28.
//

import UIKit

class CommonTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorInset = UIEdgeInsets.init(top: 0, left: Screen_W, bottom: 0, right: 0)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
