//
//  TableViewCell.swift
//  StopProcrastination
//
//  Created by 吉川椛 on 2021/01/08.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeOneLabel: UILabel!
    @IBOutlet weak var timeTwoLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    // MARK: Static properties
    
    static let reuseIdentifier = "TableViewCell"
    static let rowHeight: CGFloat = 100
    
    static var nib: UINib {
        return UINib(nibName: "TableViewCell", bundle: nil)
    }

    func setUpAccessaryCell(timeOne: String,timeTwo: String, place: String, content: String) {
        timeOneLabel.text = timeOne
        timeTwoLabel.text = timeTwo
        placeLabel.text = place
        contentLabel.text = content
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    fileprivate func commonInit() {

    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        if let indicatorButton = allSubviews.compactMap({ $0 as? UIButton }).last {
            let image = indicatorButton.backgroundImage(for: .normal)?.withRenderingMode(.alwaysTemplate)
            indicatorButton.setBackgroundImage(image, for: .normal)
            indicatorButton.tintColor = UIColor(red: 30/255, green: 49/255, blue: 63/255, alpha: 1.0)
         }
      }
    
}

extension UIView {
   var allSubviews: [UIView] {
      return subviews.flatMap { [$0] + $0.allSubviews }
   }
}
