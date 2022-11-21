//
//  NavigationMap.swift
//  collection
//
//  Created by 张晖 on 2022/5/24.
//

import Foundation
import URLNavigator

final class Navigation {
    let navigator: Navigator = Navigator()
    static let shared = Navigation()
    private init() {}
}

class NavigationMap: NSObject{
    @discardableResult
    init(navigator: Navigator) {
        navigator.register("ThingsWhere://nfc/<hoderid>") { url, values, context in
            guard let hoderid = values["hoderid"] as? String else { return nil }
            let thingsVc = ThingsListViewController(hoderId: hoderid)
            thingsVc.hidesBottomBarWhenPushed = true
            return thingsVc
        }
        
//        navigator.register("ThingsWhere://things/add") { url, values, context in
//            let thingsAddVc = ThingsAddViewController()
//            let presentationController = PresentationController.init(presentedViewController: thingsAddVc, presenting: context as? UIViewController)
//            thingsAddVc.transitioningDelegate = presentationController
//            return thingsAddVc
//        }
        
        navigator.handle("ThingsWhere://things/add") { url, values, context in
            let thingsAddVc = ThingsAddViewController()
            let presentationController = PresentationController.init(presentedViewController: thingsAddVc, presenting: context as? UIViewController)
            thingsAddVc.transitioningDelegate = presentationController
            let fromVc = context as? UIViewController
            fromVc?.present(thingsAddVc, animated: true)
            return false
        }
        
        navigator.handle("ThingsWhere://things/record") { url, values, context in
            let thingsRecordVc = ThingsRecordViewController()
            let array = context as! NSArray
            let presentationController = PresentationController.init(presentedViewController: thingsRecordVc, presenting: array.lastObject as? UIViewController)
            thingsRecordVc.transitioningDelegate = presentationController
            thingsRecordVc.currentThing = array.firstObject as? Realm_Thing
            let fromVc = array.lastObject as? UIViewController
            fromVc?.present(thingsRecordVc, animated: true)
            return false
        }
        
        navigator.handle("ThingsWhere://things/chooseNum/<maxNum>") { url, values, context in
            let chooseNumVc = ChooseNumberViewController()
            guard let maxNum = values["maxNum"] as? String else{return false}
            let presentationController = PresentationController.init(presentedViewController: chooseNumVc, presenting: context as? UIViewController)
            chooseNumVc.transitioningDelegate = presentationController
            chooseNumVc.maxNum = Int(maxNum )
            chooseNumVc.delegate = context as? choooseNumDelegate
            let fromVc = context as? UIViewController
            fromVc?.present(chooseNumVc, animated: true)
            return false
        }
    }
}
