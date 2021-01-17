//
//  DetailTableViewController.swift
//  StopProcrastination
//
//  Created by 吉川椛 on 2020/12/05.
//

import UIKit
import RealmSwift

class DetailTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var normalButton:  UIButton!
    @IBOutlet weak var highButton: UIButton!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let realm = try! Realm()
    let things = Thing()
    var levelString: String = ""
    var saveArray: Array! = [NSData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        levelLabel.text = ""
        textField.delegate = self
        textField.tintColor = .systemOrange
        
        textField.text = UserDefaults.standard.object(forKey: "name") as? String
        levelLabel.text = UserDefaults.standard.object(forKey: "level") as? String
        imageView.image = UIImage(data: UserDefaults.standard.object(forKey: "image") as! Data)
        
        if imageView.image != nil {
            alertLabel.isHidden = true
        } else {
            alertLabel.isHidden = true
        }
        
        if levelLabel.text == "そんなに重要でもない" {
            levelLabel.textColor = UIColor.systemGreen
        } else if levelLabel.text == "普通" {
            levelLabel.textColor = UIColor.systemOrange
        } else {
            levelLabel.textColor = UIColor.systemRed
        }
    }
    

    @IBAction func tappedSaveButton(_ sender: UIButton) {
        print("name", textField.text!)
        print("level", levelLabel.text!)
        things.name = textField.text!
        things.level = levelLabel.text!
        things.image = (imageView.image?.toJPEGData())!
        things.id = (UserDefaults.standard.object(forKey: "id") as? String)!
        try! realm.write {
            realm.add(things, update: .modified)
        }
        print(things)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedEasyButton(_ sender: UIButton) {
        levelLabel.text = "そんなに重要でもない"
        levelLabel.textColor = UIColor.systemGreen
    }
    @IBAction func tappedNormalButton(_ sender: UIButton) {
        levelLabel.text = "普通"
        levelLabel.textColor = UIColor.systemOrange
    }
    @IBAction func tappedHighButton(_ sender: UIButton) {
        levelLabel.text = "重要"
        levelLabel.textColor = UIColor.systemRed
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let alert: UIAlertController = UIAlertController(title: "画像を追加", message: "アルバムから選択するか、写真で撮ります。", preferredStyle: .alert)
            let albumButton: UIAlertAction = UIAlertAction(title: "カメラロールから選択", style: .default, handler: { (action: UIAlertAction!) -> Void in
                self.selectFromAlbum()
            })
            let cameraButton: UIAlertAction = UIAlertAction(title: "カメラで撮影", style: .default, handler: { (action: UIAlertAction!) -> Void in
                self.takePicture()
            })
            let cancelButton: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alert.addAction(albumButton)
            alert.addAction(cameraButton)
            alert.addAction(cancelButton)
            alert.view.tintColor = .systemOrange
            present(alert, animated: true, completion: nil)
            
            tableView.deselectRow(at: indexPath, animated: true)
            
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func selectFromAlbum() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            self.present(pickerView, animated: true)
            alertLabel.isHidden = true
        }
    }
    
    func takePicture() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .camera
            pickerView.delegate = self
            self.present(pickerView, animated: true)
            alertLabel.isHidden = true
        }
    }
    
}

extension DetailTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択した写真を取得する
        let image = info[.originalImage] as! UIImage
        // ビューに表示する
        imageView.image = image
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
}
