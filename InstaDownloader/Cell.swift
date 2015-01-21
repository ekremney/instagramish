//
//  Cell.swift
//  InstaDownloader
//
//  Created by Ekrem Doğan on 20.01.2015.
//  Copyright (c) 2015 Ekrem Doğan. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {

    @IBOutlet var postedImage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
