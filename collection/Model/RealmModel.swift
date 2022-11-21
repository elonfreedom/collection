//
//  Realm_Room.swift
//  collection
//
//  Created by 张晖 on 2022/5/16.
//

import Foundation
import RealmSwift


/// 操作状态
enum OperateState :String {
    case creat
    case add
    case reduce
    case remove
}

class Realm_Room: Object {
    @Persisted var name: String = ""
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    @Persisted var hoders = List<Realm_Hoder>()
}

class Realm_Hoder:Object {
    @Persisted var name:String = ""
    @Persisted var _id :String = ""
    @Persisted var things = List<Realm_Thing>()
    let owners = LinkingObjects(fromType:Realm_Room.self,property:"hoders")
//    convenience override init() {
//        self.init()
//    }
    override static func primaryKey() -> String {
            return "_id"
    }
}

class Realm_Thing:Object {
    @Persisted var name :String = ""
    @Persisted var describe :String = ""
    @Persisted var amount :Int = 0
    @Persisted var _id :String = ""
    @Persisted var records = List<Realm_ThingRecord>()
    let owners = LinkingObjects(fromType:Realm_Hoder.self,property:"things")
    override static func primaryKey() -> String {
            return "_id"
    }
}

class Realm_ThingRecord:Object {
    @Persisted var date : Date = Date()
    @Persisted var changeNum :Int = 0
    @Persisted var state: String = ""
    @Persisted var _id :String = ""
    @Persisted var currentNum :Int = 0
    let owners = LinkingObjects(fromType:Realm_Thing.self,property:"records")
    override static func primaryKey() -> String {
            return "_id"
    }
}
