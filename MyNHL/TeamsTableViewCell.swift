//
//  TeamsTableViewCell.swift
//  MyNHL
//
//  Created by Polina on 11/5/19.
//  Copyright © 2019 harinovskaya. All rights reserved.
//

import UIKit

class TeamsTableViewCell: UITableViewCell {

    @IBOutlet weak var teamsLA: UILabel!
    @IBOutlet weak var pointsLA: UILabel!
    @IBOutlet weak var diffLA: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
