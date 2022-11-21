//
//  MineViewController.swift
//  collection
//
//  Created by 张晖 on 2022/5/25.
//

import UIKit
import Intents


class MineViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let dataArray:NSArray = ["siri","icloud"]
    lazy var tableView:UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table .register(UINib.init(nibName: "CommonTableViewCell", bundle: nil), forCellReuseIdentifier: "CommonTableViewCellId")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CommonTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: "CommonTableViewCellId") as! CommonTableViewCell)
        cell?.backgroundColor = UIColor(named: "yellowCell")
        cell?.lblTitle.text = dataArray[indexPath.row] as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            requestSiri()
            break
        default: break
            
        }
    }
    
    func requestSiri(){
        INPreferences.requestSiriAuthorization { authorizationStatus in
                    switch authorizationStatus {
                    case .authorized:
                         print("Authorized")
                        self.donateInteraction()
                    default:
                        print("Not Authorized")
                    }
                }

    }
    
    func donateInteraction(){
        
//        let intent = ThingsWhereIntent()
//        intent.suggestedInvocationPhrase = "Things Where"
//        intent.hoder = "hoder"
//        let interaction = INInteraction(intent: intent, response: nil)
//
//        interaction.donate { (error) in
//            if error != nil {
//                if let error = error as NSError? {
//                    print("Interaction donation failed: \(error.description)")
//                } else {
//                    print("Successfully donated interaction")
//                }
//            }
//        }
        
        
        let intent = PersonInfoIntent()
        intent.suggestedInvocationPhrase = "Add person Info"
        intent.firstName = "firstName"
        let interaction = INInteraction(intent: intent, response: nil)
        
        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    print("Interaction donation failed: \(error.description)")
                } else {
                    print("Successfully donated interaction")
                }
            }
        }
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
