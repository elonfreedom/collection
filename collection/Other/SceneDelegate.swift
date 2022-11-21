//
//  SceneDelegate.swift
//  collection
//
//  Created by 张晖 on 2022/3/28.
//

import UIKit
import URLNavigator
import Foundation
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
 
        NavigationMap.init(navigator: Navigation.shared.navigator)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let timeline = MainTabBarController()
            window.rootViewController = timeline
            self.window = window
            window.makeKeyAndVisible()
        }
        
        //应用程序关闭情况下调用通用链接
        if let userActivity = connectionOptions.userActivities.first {
            if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
                if let webUrl = userActivity.webpageURL, let host = webUrl.host {
                          if host == "www.zhids.top" {
                              let savepush = UserDefaults.standard
                              savepush.set("ThingsWhere:/\(webUrl.path)", forKey: "push")
                              savepush.synchronize()
                          }
                       }
            }
        }
    }
    
    func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String) {
        
    }
    
    /// 在后台或者在前台，调用通用链接
    /// - Parameters:
    ///   - scene: <#scene description#>
    ///   - userActivity: <#userActivity description#>
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let webUrl = userActivity.webpageURL, let host = webUrl.host {
                      if host == "www.zhids.top" {
                          NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: Notification_NfcUrlPush), object: "ThingsWhere:/\(webUrl.path)")
                      } else {
                          
                      }
                   }
        }
    }
    
    func scene(_ scene: UIScene, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("didBecomeActive")

        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("WillResignActive")

        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("willEnterForeground")
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("didEnterForeground")
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
//        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

