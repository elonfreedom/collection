//
//  ThingsManager.swift
//  collection
//
//  Created by 张晖 on 2022/5/17.
//

import RealmSwift

let realm = try! Realm()

class ThingsManager {
    static let shared = ThingsManager()
    
    /// 添加房间
    /// - Parameter room: <#room description#>
    func saveRoom(_ room:Realm_Room){
        try! realm.write({
            realm.add(room)
        })
    }
    
    /// 添加容器
    /// - Parameters:
    ///   - room: <#room description#>
    ///   - hoder: <#hoder description#>
    func saveHoder(_ room:Realm_Room , hoder:Realm_Hoder){
        try! realm.write{
            room.hoders.append(hoder)
        }
    }
    
    /// 添加物品
    /// - Parameters:
    ///   - hoder: <#hoder description#>
    ///   - thing: <#thing description#>
    func saveThing(_ hoder:Realm_Hoder , thing:Realm_Thing){
        try! realm.write({
            hoder.things.append(thing)
        })
    }
    
    
    /// 添加物品操作记录
    /// - Parameters:
    ///   - thing: <#thing description#>
    ///   - record: <#record description#>
    func saveRecord(_ thing:Realm_Thing, record:Realm_ThingRecord){
        try! realm.write({
            thing.records.append(record)
        })
    }
    
    
    func editThingAmount(_ thing:Realm_Thing, amount:Int){
        try! realm.write({
            thing.amount = amount
        })
    }
    
    /// 删除容器
    /// - Parameter hoder: <#hoder description#>
    func deleteHoder(_ hoder:Realm_Hoder){
        try! realm.write({
            let things = hoder.things
            realm.delete(things)
            realm.delete(hoder)
        })
    }
    
    /// 删除物品
    /// - Parameter hoder: <#hoder description#>
    func deleteThing(_ thing:Realm_Thing){
        try! realm.write({
            realm.delete(thing)
        })
    }
    
}
