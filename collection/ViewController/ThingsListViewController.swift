//
//  ThingsListViewController.swift
//  collection
//
//  Created by 张晖 on 2022/5/6.
//

import UIKit
import RealmSwift
import URLNavigator

class ThingsListViewController: BaseViewController,NfcDelegate,UITableViewDelegate,UITableViewDataSource,choooseNumDelegate{
    var currentHoder:Realm_Hoder!
    var nfcTool:NFCTool = NFCTool()
    var operating:OperateState!//即将要操作的状态
    var operatingThing:Realm_Thing?//即将要操作的物品
    lazy var tableView:UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        table.register(UINib.init(nibName: "ThingsTableViewCell", bundle: nil), forCellReuseIdentifier: "ThingsTableViewCellId")
        table.separatorStyle = .none
        return table
    }()
    
    convenience init(hoderId : String) {
        self.init()
        self.currentHoder = realm.object(ofType: Realm_Hoder.self, forPrimaryKey: hoderId)
        if  self.currentHoder == nil {
            return
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nfcTool.delegate = self
        self.navigationItem.title = currentHoder.name
        let rightButton:UIButton = UIButton.init(type: .custom)
        rightButton.setImage(UIImage.init(systemName: "ellipsis"), for: .normal)
        rightButton.addTarget(self, action: #selector(more(_:)), for: .touchUpInside)
//        let rightItem:UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(systemName: "ellipsis"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(more(_:)))
        let rightItem:UIBarButtonItem = UIBarButtonItem.init(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightItem
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(cellLongPress(_:)))
        tableView.addGestureRecognizer(longPress)
        
        let freeBtn = FreeMoveButton(frame: CGRect(x: self.view.bounds.width-60, y: self.view.bounds.height - 2*NavigationBar_H, width: 60, height: 60))
        freeBtn.customImage = UIImage.init(systemName: "plus.circle")?.withTintColor(UIColor(named: "normalText")!, renderingMode: .alwaysOriginal)
        freeBtn.backgroundColor = UIColor(named: "radioColor")
        self.view.addSubview(freeBtn)
        
        freeBtn.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-2*NavigationBar_H)
        }
        
        freeBtn.clickCompletCloser = {
            Navigation.shared.navigator.open("ThingsWhere://things/add", context: self)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(thingAdd), name: NSNotification.Name(rawValue: Notification_ThingsAdded), object: nil)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func more(_ sender:UIButton){
        let alertsheet:UIAlertController = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alertsheet.popoverPresentationController?.sourceView = sender
        alertsheet.popoverPresentationController?.sourceRect = sender.bounds
        let alertNfc:UIAlertAction = UIAlertAction.init(title: "修改NFC标签", style: UIAlertAction.Style.default) { [self] nfc in
            nfcTool.writeNFCData(url: "zhids.top/nfc/"+currentHoder._id)
        }
//        let alertName:UIAlertAction = UIAlertAction.init(title: "修改容器名称", style: UIAlertAction.Style.default) { [self] name in

//        }
        
        let alertDelete:UIAlertAction = UIAlertAction.init(title: "删除", style: UIAlertAction.Style.destructive) { [self] delete in
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: Notification_HoderDeleted), object: currentHoder)
            ThingsManager.shared.deleteHoder(currentHoder)
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        let alertCancel :UIAlertAction = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel)
        alertsheet.addAction(alertNfc)
//        alertsheet.addAction(alertName)
        alertsheet.addAction(alertDelete)
        alertsheet.addAction(alertCancel)
        //显示alert controller
        self.present(alertsheet, animated: true, completion: nil)
    }
    
    @objc func cellLongPress(_ pressGesture:UILongPressGestureRecognizer){
//        var currentIndexPath:NSIndexPath?
        if (pressGesture.state == .began) {//手势开始
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            let point = pressGesture.location(in: self.tableView)
            let currentIndexPath = self.tableView.indexPathForRow(at: point) as NSIndexPath?
            if currentIndexPath != nil {
                operateThing(thing: self.currentHoder.things[currentIndexPath!.row])
            }
        }
    }
    
    @objc func thingAdd(noti: Notification){
        let data : NSArray = noti.object as! NSArray
        let thing = Realm_Thing()
        thing.name = data.firstObject as! String
        thing._id = Date().milliStamp
        thing.amount = Int(data.lastObject as! String) ?? 0
        ThingsManager.shared.saveThing(self.currentHoder, thing: thing)
        
        let record = Realm_ThingRecord()
        record.state = OperateState.creat.rawValue
        record.changeNum = thing.amount
        record.currentNum = thing.amount
        record.date = Date()
        record._id = thing._id + Date().timeStamp
        ThingsManager.shared.saveRecord(thing, record: record)
        
        self.tableView.reloadData()
    }
    
    func NfcReadResult(url: String) {
        print(url)
    }
    
    func NfcWriteResult(result: Bool) {
        print("写入成功")
    }
    
    //MARK: tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentHoder.things.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let thing:Realm_Thing = currentHoder.things[indexPath.row]
        let cell:ThingsTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: "ThingsTableViewCellId") as! ThingsTableViewCell)
//        cell?.backViewColor = UIColor(named: "yellowCell")
//        cell?.selectionColor = UIColor(named: "selectionColor")
        cell?.backView.backgroundColor = UIColor(named: "yellowCell")
        cell?.backgroundColor = UIColor.clear
        cell?.lblTitle.text = thing.name
        cell?.lblAmount.text = "\(thing.amount)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thing:Realm_Thing = currentHoder.things[indexPath.row]
        Navigation.shared.navigator.open("ThingsWhere://things/record", context: [thing,self])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    func operateThing(thing:Realm_Thing){
        let alertController :UIAlertController = UIAlertController.init(title: "操作物品", message: nil, preferredStyle: UIAlertController.Style.alert)
        let addAction : UIAlertAction = UIAlertAction(title: "补货", style: UIAlertAction.Style.default) { actionChange in
            self.operating = .add
            self.operatingThing = thing
            Navigation.shared.navigator.open("ThingsWhere://things/chooseNum/30)", context:self)
        }
        let alertAction : UIAlertAction = UIAlertAction(title: "取出", style: UIAlertAction.Style.default, handler: { (param : UIAlertAction!) -> Void in
            self.operating = .reduce
            self.operatingThing = thing
            print("ThingsWhere://things/chooseNum/\(thing.amount)")
            Navigation.shared.navigator.open("ThingsWhere://things/chooseNum/\(thing.amount)", context:self)
        })
        let changeAction : UIAlertAction = UIAlertAction(title: "转移", style: UIAlertAction.Style.default) { actionChange in
            self.operatingThing = thing

        }
        
        let deleteAction : UIAlertAction = UIAlertAction(title: "删除", style: UIAlertAction.Style.destructive) { actionDelete in
            ThingsManager.shared.deleteThing(thing)
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: Notification_ThingsChanged), object: nil)
            self.tableView.reloadData()
        }
        let cancelAction : UIAlertAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel)
        alertController.addAction(addAction)
        alertController.addAction(alertAction)
        alertController.addAction(changeAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        //显示alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func changeNum(NewNum: Int) {
        let record = Realm_ThingRecord()
        record.state = self.operating!.rawValue
        record.changeNum = NewNum
        //只在选择数量后执行
        if self.operating == OperateState.reduce {
            record.currentNum = self.operatingThing!.amount - record.changeNum
        }else{
            record.currentNum = self.operatingThing!.amount + record.changeNum
        }
        record.date = Date()
        record._id = self.operatingThing!._id + Date().timeStamp
        ThingsManager.shared.saveRecord(self.operatingThing!, record: record)
        ThingsManager.shared.editThingAmount(self.operatingThing!, amount: record.currentNum)
        self.tableView.reloadData()
    }
}
