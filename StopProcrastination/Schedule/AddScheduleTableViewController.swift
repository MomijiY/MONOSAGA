//
//  AddScheduleTableViewController.swift
//  StopProcrastination
//
//  Created by 吉川椛 on 2021/01/09.
//

import UIKit
import RealmSwift
import os

class AddScheduleTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var timeOneTextField: UITextField!
    @IBOutlet weak var timeTwoTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    var items = AddDate()
    var timePicker: UIDatePicker = UIDatePicker()
    var timePicker2: UIDatePicker = UIDatePicker()
    
    let identifier = UUID().uuidString
    let finishIdentifier = UUID().uuidString
    
    let content = UNMutableNotificationContent()
    let Finishcontent = UNMutableNotificationContent()
    
    var request:UNNotificationRequest!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeOneTextField.becomeFirstResponder()
        self.setNeedsStatusBarAppearanceUpdate()
        timeOneTextField.delegate = self
        timeTwoTextField.delegate = self
        placeTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        setUpPicker()
        textFieldTintColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }
    
    @IBAction func saveImDate(_ sender: UIBarButtonItem) {
        saveImDate()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        timeOneTextField.resignFirstResponder()
        timeTwoTextField.resignFirstResponder()
        placeTextField.resignFirstResponder()
        return true
    }
    
    func setUpPicker() {
        timePicker.datePickerMode = .dateAndTime
        timePicker.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        timeOneTextField.inputView = timePicker
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.addTarget(self, action: #selector(changedTimePicker1Value), for: .valueChanged)
        
        timePicker2.datePickerMode = .dateAndTime
        timePicker2.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        timeTwoTextField.inputView = timePicker2
        timePicker2.preferredDatePickerStyle = .wheels
        timePicker2.addTarget(self, action: #selector(changedTimePicker2Value), for: .valueChanged)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        spacelItem.tintColor = .systemOrange
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        doneItem.tintColor = .systemOrange
        toolbar.setItems([spacelItem, doneItem], animated: true)

        let toolbar2 = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        spacelItem2.tintColor = .systemOrange
        let doneItem2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done2))
        doneItem2.tintColor = .systemOrange
        toolbar2.setItems([spacelItem2, doneItem2], animated: true)
        
        let toolbar3 = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        spacelItem3.tintColor = .systemOrange
        let doneItem3 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done3))
        doneItem3.tintColor = .systemOrange
        toolbar3.setItems([spacelItem3, doneItem3], animated: true)
        
        timeOneTextField.inputView = timePicker
        timeTwoTextField.inputView = timePicker2
        timeOneTextField.inputAccessoryView = toolbar
        timeTwoTextField.inputAccessoryView = toolbar2
        contentTextView.inputAccessoryView = toolbar3
    }
    
    func textFieldTintColor() {
        timeOneTextField.tintColor = .systemOrange
        timeTwoTextField.tintColor = .systemOrange
        placeTextField.tintColor = .systemOrange
        contentTextView.tintColor = .systemOrange
    }
    
    @objc func changedTimePicker1Value() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d HH:mm"
        timeOneTextField.text = "\(formatter.string(from: timePicker.date))"
    }
    
    @objc func changedTimePicker2Value() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d HH:mm"
        timeTwoTextField.text = "\(formatter.string(from: timePicker2.date))"
    }
    
    @objc func done() {
        timeOneTextField.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d HH:mm"
        timeOneTextField.text = "\(formatter.string(from: timePicker.date))"
    }
    
    @objc func done2() {
        timeTwoTextField.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d HH:mm"
        timeTwoTextField.text = "\(formatter.string(from: timePicker2.date))"
    }
    
    @objc func done3() {
        contentTextView.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension AddScheduleTableViewController {
    
    
    func saveImDate() {
        if placeTextField.text == "" {
            let alertController: UIAlertController = UIAlertController(title: "空欄があります。", message: "場所を入力してください。", preferredStyle: .alert)
            let okButton: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okButton)
            self.present(alertController, animated: true, completion: nil)
        } else {
            items.time1 = timeOneTextField.text!
            items.time2 = timeTwoTextField.text!
            items.place = placeTextField.text!
            items.content = contentTextView.text
            items.identifier = identifier
            let realm = try! Realm()
            try! realm.write{
                let events = [AddDate(value: ["time1": items.time1,
                                              "time2": items.time2,
                                              "place": items.place,
                                              "content": items.content,
                                              "identifier": items.identifier,
                                              "id": UUID().uuidString])]
                realm.add(events)
                print(events)
            }
            os_log("setButton")
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            dateFormatter.dateStyle = .medium
            dateFormatter.locale = Locale(identifier: "ja_JP")
                   
            let otherDate1 = timePicker.date
            print("otherDate1: \(otherDate1)")
            let targetDate = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: otherDate1)
            print("ターゲットは\(targetDate)")
            
            let trigger = UNCalendarNotificationTrigger.init(dateMatching: targetDate, repeats: false)
            content.title = "予定があります。忘れ物をしないようにしましょう！"
            content.body = dateFormatter.string(from: otherDate1)
            content.sound = UNNotificationSound.default
            request = UNNotificationRequest.init(
                    identifier: identifier,
                    content: content,
                    trigger: trigger)
            UserDefaults.standard.set(identifier, forKey: "identifier")
            UserDefaults.standard.set(content.title, forKey: "notiContent")
            let center = UNUserNotificationCenter.current()
            center.add(request)
            self.navigationController?.popViewController(animated: true)
        }

    }
}
