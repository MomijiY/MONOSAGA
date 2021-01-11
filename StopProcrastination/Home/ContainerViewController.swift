//
//  ContainerViewController.swift
//  StopProcrastination
//
//  Created by 吉川椛 on 2020/11/22.
//

import UIKit
import RealmSwift

class ContainerTableViewController: UITableViewController, UITextFieldDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        levelLabel.text = ""
        textField.delegate = self
        textField.tintColor = .systemOrange
        alertLabel.isHidden = false
    }
    

    @IBAction func tappedSaveButton(_ sender: UIButton) {
        things.name = textField.text!
        things.level = levelLabel.text!
        things.image = (imageView.image?.toJPEGData())!
        try! realm.write {
            let thing = [Thing(value: ["name": things.name, "level": things.level, "image": things.image, "id": UUID().uuidString])]
            realm.add(thing)
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

extension ContainerTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
