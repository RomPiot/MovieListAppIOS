//
//  MovieTableViewCell.swift
//  IosProject
//
//  Created by  on 04/03/2020.
//  Copyright © 2020 romain. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
