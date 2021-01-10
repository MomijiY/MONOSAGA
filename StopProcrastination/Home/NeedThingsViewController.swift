//
//  NeedThingsTableViewController.swift
//  StopProcrastination
//
//  Created by 吉川椛 on 2020/11/22.
//

import UIKit
import RealmSwift

class NeedThingsViewController: UITableViewController, UITextFieldDelegate {
    
    let realm = try! Realm()
    let cellHeight: CGFloat =  80
    var arrayThings = [Thing]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(NeedThingsTableViewCell.nib, forCellReuseIdentifier: NeedThingsTableViewCell.reuseIdentifier)
        tableView.allowsMultipleSelection = true
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadThings()
    }
    
    func loadThings() {
        let results = realm.objects(Thing.self).sorted(byKeyPath: "level")
        arrayThings = [Thing]()
        for t in results {
            arrayThings.append(t)
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayThings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NeedThingsTableViewCell.reuseIdentifier, for: indexPath) as! NeedThingsTableViewCell
        let content =  arrayThings[indexPath.row]
        cell.setUpCell(name: content.name, level: content.level, image: content.image)
        print("arrayThings: ",arrayThings)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let things = arrayThings[indexPath.row]
        UserDefaults.standard.set(things.name, forKey: "name")
        UserDefaults.standard.set(things.level, forKey: "level")
        UserDefaults.standard.set(things.image, forKey: "image")
        UserDefaults.standard.set(things.id, forKey: "id")
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCell.EditingStyle.delete) {
            try! realm.write {
                realm.delete(arrayThings[indexPath.row])
                arrayThings.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
        }
    }
}
