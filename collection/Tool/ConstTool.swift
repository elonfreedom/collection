//
//  ConstTool.swift
//  collection
//
//  Created by 张晖 on 2022/5/12.
//

import Foundation
import UIKit

let Screen_W = UIScreen.main.bounds.size.width
let Screen_H = UIScreen.main.bounds.size.height

//let Screen_W = UIScreen.main.currentMode!.size.width
//let Screen_H = UIScreen.main.currentMode!.size.height

let Scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
let StatusBarFrame = Scene?.statusBarManager?.statusBarFrame
let StatusBar_H = StatusBarFrame?.height
let NavigationBar_H = (StatusBar_H ?? 0) + 44


let Notification_HoderNameChanged : String  = "notification_hoderNameChanged"
let Notification_HoderDeleted: String = "notification_hoderDeleted"
let Notification_ThingsChanged:String = "notification_thingsChange"
let Notification_ThingsAdded:String = "notification_thingsAdded"
let Notification_NfcUrlPush:String = "notification_NfcUrlPush"

extension OperateState{
    var zh_CN_String :String{
        switch self {
        case .creat:
            return "创建"
        case .add:
            return "补货"
        case .reduce:
            return "取出"
        default:
            return ""
        }
    }
}

extension Date {
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    var dateString :String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
    func date2String(_ dateFormat:String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: self)
        return date
    }
}

extension UIImage{
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) {
            UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
            defer {
                UIGraphicsEndImageContext()
            }
            let context = UIGraphicsGetCurrentContext()
            context?.setFillColor(color.cgColor)
            context?.fill(CGRect(origin: CGPoint.zero, size: size))
            context?.setShouldAntialias(true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            guard let cgImage = image?.cgImage else {
                self.init()
                return nil
            }
            self.init(cgImage: cgImage)
        }
}



