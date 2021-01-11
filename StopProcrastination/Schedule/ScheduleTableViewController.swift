//
//  ScheduleTableViewController.swift
//  StopProcrastination
//
//  Created by 吉川椛 on 2021/01/08.
//

import UIKit
import RealmSwift

class ScheduleTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var items = [AddDate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        tableView.tableFooterView = UIView()
        
        loadSchedule()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSchedule()
    }
    
    func loadSchedule() {
        items = [AddDate]()
        
        let realm = try! Realm()
        let results = realm.objects(AddDate.self).sorted(byKeyPath: "time1")
        items = [AddDate]()
        for ev in results {
            items.append(ev)
        }
        tableView.reloadData()
    }

}

extension ScheduleTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as! TableViewCell
        let memo = items[indexPath.row]
        cell.setUpAccessaryCell(timeOne: memo.time1, timeTwo: memo.time2, place: memo.place, content: memo.content)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let memo = items[indexPath.row]
        UserDefaults.standard.set(memo.time1, forKey: "time1")
        UserDefaults.standard.set(memo.time2, forKey: "time2")
        UserDefaults.standard.set(memo.place, forKey: "place")
        UserDefaults.standard.set(memo.content, forKey: "content")
        self.performSegue(withIdentifier: "toScheduleDetail", sender: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            let realm = try! Realm()
            try! realm.write {
                print("削除")
                realm.delete(items[indexPath.row])
                items.remove(at: indexPath.row)
                tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
                tableView.reloadData()
            }
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = TableViewCell.rowHeight
        tableView.register(TableViewCell.nib, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
}

