//
//  Things.swift
//  StopProcrastination
//
//  Created by 吉川椛 on 2020/11/22.
//

import Foundation
import RealmSwift

class Thing: Object {
    @objc dynamic var name = ""
    @objc dynamic var level = ""
    @objc dynamic var image = Data()
    @objc dynamic var id = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}

import UIKit

/// UIImage拡張(データ)
public extension UIImage {
    func toJPEGData() -> Data {
        guard let data = self.jpegData(compressionQuality: 1.0) else {
            print("イメージをJPEGデータに変換できませんでした。")
            return Data()
        }

        return data
    }

}
