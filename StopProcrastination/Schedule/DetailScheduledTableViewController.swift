//
//  DetailScheduledTableViewController.swift
//  StopProcrastination
//
//  Created by 吉川椛 on 2021/01/09.
//

import UIKit

class DetailScheduledTableViewController: UITableViewController, UICollectionViewDelegate {

    @IBOutlet weak var timeOneLabel: UITextField!
    @IBOutlet weak var timeTwoLabel: UITextField!
    @IBOutlet weak var placeLabel: UITextField!
    @IBOutlet weak var contentLabel: UITextView!
    
    private var addDate: AddDate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //status bar
        self.setNeedsStatusBarAppearanceUpdate()
        configureUI()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension DetailScheduledTableViewController {
    
    func configureUI() {
        timeOneLabel.text = UserDefaults.standard.object(forKey: "time1") as? String
        timeTwoLabel.text = UserDefaults.standard.object(forKey: "time2") as? String
        placeLabel.text = UserDefaults.standard.object(forKey: "place") as? String
        contentLabel.text = UserDefaults.standard.object(forKey: "content") as? String
        
        timeOneLabel.isEnabled = false
        timeTwoLabel.isEnabled = false
        placeLabel.isEnabled = false
        contentLabel.isEditable = false
    }
}
