//
//  MainTabBarController.swift
//  collection
//
//  Created by 张晖 on 2022/3/28.
//

import UIKit


class MainTabBarController: UITabBarController,UITabBarControllerDelegate {

    lazy var firstVc:IndexViewController = {
       let vc = IndexViewController()
        vc.title = "哪儿"
        return vc
    }()
    
    
    lazy var thirdVc:MineViewController = {
        let vc = MineViewController()
        vc.title = "在呢"
        return vc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllerTabBarItem()
        setTabBar()
        // Do any additional setup after loading the view.
    }
    

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setViewControllerTabBarItem(){
        let controllerArray:[BaseViewController] = [firstVc,thirdVc]
//        let titleArray:[String] = ["位置","NFC"]
        let imageArray:[String] = ["circle.grid.cross.fill","person.fill"]
        let imageSelectedArray:[String] = ["circle.grid.cross.fill","person.fill"]
        for index in 0..<controllerArray.count{
            let item = UITabBarItem.init(title:"", image: UIImage.init(systemName: imageArray[index]), selectedImage:UIImage.init(systemName: imageSelectedArray[index]))
            let controller = controllerArray[index]
            controller.tabBarItem = item
        }
    }
    
    func setTabBar(){
        self.tabBar.barTintColor = .white
//        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor(named: "tabbarUnselectColor")
        self.tabBar.unselectedItemTintColor = UIColor(named: "normalText")
        let firstPage = NavigationController.init(rootViewController: firstVc)
//        let secondPage = NavigationController.init(rootViewController: secVc)
        let thirdPage = NavigationController.init(rootViewController: thirdVc)
//        let fourPage = NavigationController.init(rootViewController: fourVc)
        self.viewControllers = [firstPage,thirdPage]
        self.delegate = self
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
