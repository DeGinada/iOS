//
//  InfomationTableViewCell.swift
//  Happy1000won
//
//  Created by Sora Yeo on 2017. 7. 13..
//  Copyright © 2017년 DeGi. All rights reserved.
//

import UIKit

class InfomationTableViewCell: UITableViewCell {

    @IBOutlet weak var imgThumbnail: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbPlace: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
