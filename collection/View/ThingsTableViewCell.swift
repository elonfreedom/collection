//
//  ThingsTableViewCell.swift
//  collection
//
//  Created by 张晖 on 2022/5/25.
//

import UIKit

class ThingsTableViewCell: UITableViewCell {
    
    var backViewColor:UIColor?
    var selectionColor:UIColor?
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorInset = UIEdgeInsets.init(top: 0, left: Screen_W, bottom: 0, right: 0)
        self.backView.layer.cornerRadius = 10
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        if (selected) {
//                self.backView.backgroundColor = selectionColor
//            } else {
//                self.backView.backgroundColor = backViewColor
//            }
//        // Configure the view for the selected state
//    }
//    
//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        super.setHighlighted(highlighted, animated: animated)
//        if highlighted {
//            self.backView.backgroundColor = self.selectionColor
//        }else{
//            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
//                self.backView.backgroundColor = self.backViewColor
//            } completion: { isComplete in
//                
//            }
//
//        }
//    }
    
}
