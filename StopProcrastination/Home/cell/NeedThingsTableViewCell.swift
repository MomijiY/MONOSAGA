//
//  NeedThingsTableViewCell.swift
//  StopProcrastination
//
//  Created by 吉川椛 on 2020/11/23.
//

import UIKit

class NeedThingsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelButton: UIButton!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var thingImageView: UIImageView!
    
//    let levelImage = UIImage(named: "circle.fill")
    override func awakeFromNib() {
        super.awakeFromNib()
        levelButton.isEnabled = false
        levelLabel.isHidden = true
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let reuseIdentifier = "NeedThingsTableViewCell"
    static let rowHeight: CGFloat = 80
    static var nib: UINib {
        return UINib(nibName: "NeedThingsTableViewCell", bundle: nil)
    }
    
    func setUpCell(name: String, level: String, image: Data) {
        nameLabel.text = name
        levelLabel.text = level
        thingImageView.image = UIImage(data: image)
        print(image)
        if levelLabel.text == "そんなに重要でもない" {
            levelButton.tintColor = UIColor.systemGreen
        } else if levelLabel.text == "普通" {
            levelButton.tintColor = UIColor.systemOrange
        } else {
            levelButton.tintColor = UIColor.systemRed
        }
    }
    
}

