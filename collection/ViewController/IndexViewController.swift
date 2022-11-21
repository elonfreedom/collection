//
//  IndexViewController.swift
//  collection
//
//  Created by 张晖 on 2022/3/28.
//

import UIKit
import SnapKit
import RealmSwift
import URLNavigator

class IndexViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,NfcDelegate {
    
    var dataArray:NSMutableArray = NSMutableArray.init()
//    let tool :NFCTool = NFCTool()
    var isBeganMove:Bool = false
    var hoderName = ""
    var hoderId = ""
    var hoderList: Results<Realm_Hoder>!
//    var currentRoom :Realm_Room?
    
    lazy var collectionView:UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: 170, height: 100)
        collectionViewLayout.minimumLineSpacing=14
        collectionViewLayout.minimumInteritemSpacing=5
        collectionViewLayout.sectionInset = UIEdgeInsets.init(top: 14, left: 14, bottom: 14, right: 14)
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "CommonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CommonCollectionViewCellId")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let roomList = realm.objects(Realm_Room.self)
        if roomList.count==0 {
            let defaultRoom = Realm_Room()
            defaultRoom.name = "默认房间"
            ThingsManager.shared.saveRoom(defaultRoom)
        }
        
        hoderList = realm.objects(Realm_Hoder.self)
        for item in hoderList {
            self.dataArray.add(item)
        }
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let rightItem:UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(systemName: "plus",withConfiguration: UIImage.SymbolConfiguration(weight: .bold)), style: UIBarButtonItem.Style.plain, target: self, action: #selector(addRoom))
        self.navigationItem.rightBarButtonItem = rightItem
        collectionView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataChanged), name: NSNotification.Name(rawValue: Notification_HoderNameChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataDelete), name: NSNotification.Name(rawValue: Notification_HoderDeleted), object: nil )
        NotificationCenter.default.addObserver(self, selector: #selector(pushtovc), name: NSNotification.Name(rawValue: Notification_NfcUrlPush), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataChanged), name: NSNotification.Name(rawValue: Notification_ThingsChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataChanged), name: NSNotification.Name(rawValue: Notification_ThingsAdded), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchPush()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: collectionView delegate
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CommonCollectionViewCell? = (collectionView.dequeueReusableCell(withReuseIdentifier: "CommonCollectionViewCellId", for: indexPath)) as? CommonCollectionViewCell
        let hoder = hoderList[indexPath.item]
        cell?.lblThingsCount.text = "\(hoder.things.count)"
        cell?.lblTitle.text = hoder.name
        cell?.backgroundColor = UIColor(named: "yellowCell")
        cell?.layer.cornerRadius = 10
        
        //添加长按手势
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(moveCollectionViewCell(sender:)))
        cell?.addGestureRecognizer(longPress)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hoder:Realm_Hoder = dataArray[indexPath.item] as! Realm_Hoder
        Navigation.shared.navigator.push("ThingsWhere://nfc/\(hoder._id)")
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let a = dataArray.object(at: sourceIndexPath.item)
        dataArray.removeObject(at: sourceIndexPath.item)
        dataArray.insert(a, at: destinationIndexPath.item)
    }
    
    @objc func moveCollectionViewCell(sender:UILongPressGestureRecognizer){
        switch sender.state {
        case .began:
            if !isBeganMove {
                isBeganMove = true
                let selectedIndexPath:NSIndexPath = collectionView.indexPathForItem(at: sender.location(in: collectionView))! as NSIndexPath
                collectionView.beginInteractiveMovementForItem(at: selectedIndexPath as IndexPath)
            }
            break
        case .changed:
            collectionView .updateInteractiveMovementTargetPosition(sender.location(in: collectionView))
            break
        case .ended:
            isBeganMove = false
            collectionView .endInteractiveMovement()
            break
        default:
            collectionView .cancelInteractiveMovement()
            break
        }
    }
    
    @objc func addRoom(){
        let alertController :UIAlertController = UIAlertController.init(title: "添加一个容器", message: nil, preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { textfield in
            textfield.placeholder = "输入容器名称"
        }
        let alertAction : UIAlertAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (param : UIAlertAction!) -> Void in
            self.hoderName = alertController.textFields?.first?.text! ?? "默认容器"
//            self.str = ("thingswhere.com/nfc/"+(alertController.textFields?.first?.text ?? "默认容器")).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            self.hoderId = Date().timeStamp
            let currentRoom = realm.objects(Realm_Room.self).first
            let hoder = Realm_Hoder()
            hoder.name = self.hoderName
            hoder._id = self.hoderId
            ThingsManager.shared.saveHoder(currentRoom!, hoder: hoder)
            self.dataArray.add(hoder)
            self.collectionView.reloadData()
//            self.tool.writeNFCData(url: "zhids.top/nfc/"+Date().timeStamp)
        })
        let cancelAction : UIAlertAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel)
        alertController.addAction(alertAction)
        alertController.addAction(cancelAction)
        //显示alert controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func dataChanged(noti: Notification){
        self.collectionView.reloadData()
    }
    
    @objc func dataDelete(noti: Notification){
        let hoder:Realm_Hoder = noti.object as! Realm_Hoder
        self.dataArray.remove(hoder)
        self.collectionView.reloadData()
    }
    
    func NfcWriteResult(result: Bool) {
        if result {
            DispatchQueue.main.async {
                let currentRoom = realm.objects(Realm_Room.self).first
                let hoder = Realm_Hoder()
                hoder.name = self.hoderName
                hoder._id = self.hoderId
                ThingsManager.shared.saveHoder(currentRoom!, hoder: hoder)
                self.dataArray.add(hoder)
                self.collectionView.reloadData()
            }
        }
    }
    
    func searchPush(){
        let userdefaults = UserDefaults.standard
        let pushUrl:String = userdefaults.object(forKey: "push") as? String ?? ""
        if pushUrl.isEmpty {
            return
        }else{
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: Notification_NfcUrlPush), object: pushUrl)
        }
    }
    
    @objc func pushtovc(noti: Notification){
        let url:String = noti.object as! String
        DispatchQueue.main.async {
            let userdefaults = UserDefaults.standard
            userdefaults.removeObject(forKey: "push")
            userdefaults.synchronize()
            Navigation.shared.navigator.push(url)
        }
    }

}




