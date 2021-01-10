//
//  Evemt.swift
//  StopProcrastination
//
//  Created by 吉川椛 on 2021/01/08.
//

import Foundation
import RealmSwift

class AddDate: Object {
    @objc dynamic var time1: String = ""
    @objc dynamic var time2: String = ""
    @objc dynamic var place: String = ""
    @objc dynamic var content: String = ""
}
