//
//  NavigationController.swift
//  collection
//
//  Created by 张晖 on 2022/5/19.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = UIColor(named: "normalText")
        self.navigationBar.isTranslucent = true
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundEffect = nil
        barAppearance.titleTextAttributes = {[
            NSAttributedString.Key.foregroundColor: UIColor(named: "normalText") as Any]}()
        barAppearance.backgroundColor = UIColor(named: "ThemeColor")
        barAppearance.shadowImage = UIImage()
        barAppearance.shadowColor = nil
        self.navigationBar.scrollEdgeAppearance = barAppearance;
        self.navigationBar.standardAppearance = barAppearance
//        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "backgroundColor")
//        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "backgroundColor")
//        UINavigationBar.appearance().tintColor =  UIColor(named: "backgroundColor")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
