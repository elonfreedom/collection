//
//  RecordTableViewCell.swift
//  collection
//
//  Created by 张晖 on 2022/6/1.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblOperateState: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backView.layer.cornerRadius = 10
        self.separatorInset = UIEdgeInsets.init(top: 0, left: Screen_W, bottom: 0, right: 0)
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
