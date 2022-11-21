//
//  ThingsAddViewController.swift
//  collection
//
//  Created by 张晖 on 2022/5/26.
//

import UIKit

class ThingsAddViewController: BaseViewController, UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate {
    var canReisze : Bool = false
    
    var moveView :UIView!
    
    var inputThingsName : UITextField!
    var inputThingsNum :UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredContentSizeWithTraitCollection(traitCollection: self.traitCollection)
        configureUI_MoveTop()
        configureUI_MainView()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        updatePreferredContentSizeWithTraitCollection(traitCollection: newCollection)
    }
    
    func updatePreferredContentSizeWithTraitCollection(traitCollection:UITraitCollection){
        self.preferredContentSize = CGSize.init(width: self.view.bounds.size.width, height: traitCollection.verticalSizeClass == .compact ?270:620)
    }
    
    func configureUI_MoveTop(){
        moveView = UIView()
        self.view.addSubview(moveView)
        moveView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(60)
            make.top.equalToSuperview()
        }
        
        let line1 = UIView()
        line1.backgroundColor = UIColor(named: "lineColor")
        moveView.addSubview(line1)
        
        line1.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalTo(40)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.4)
        }
        
        let line2 = UIView()
        line2.backgroundColor = UIColor(named: "lineColor")
        moveView.addSubview(line2)
        
        line2.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalTo(40)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.75)
        }
        
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(longPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        moveView.addGestureRecognizer(longPressGesture)
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(pan(_:)))
        panGesture.delegate = self
        moveView.addGestureRecognizer(panGesture)
    }
    
    func configureUI_MainView(){
        inputThingsName = UITextField()
        inputThingsName.placeholder = "是什么"
        inputThingsName.font = UIFont.boldSystemFont(ofSize: 20)
        self.view.addSubview(inputThingsName)
        
        inputThingsNum = UITextField()
        inputThingsNum.placeholder = "有多少"
        inputThingsNum.font = UIFont.boldSystemFont(ofSize: 20)
        inputThingsNum.keyboardType = .phonePad
        self.view.addSubview(inputThingsNum)
        
        inputThingsName.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(moveView.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.height.greaterThanOrEqualTo(40)
        }
        inputThingsNum.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(inputThingsName.snp.bottom).offset(30)
            make.right.equalToSuperview().offset(-20)
            make.height.greaterThanOrEqualTo(40)
        }
        
        let sureButton = UIButton.init(type: .custom)
        sureButton.setTitle("添加物品", for: .normal)
        sureButton.backgroundColor = UIColor(named: "yellowCell")
        sureButton.layer.cornerRadius = 10
        sureButton.layer.masksToBounds = true
        sureButton.setTitleColor(UIColor(named: "normalText"), for: .normal)
        sureButton.addTarget(self, action: #selector(addThing), for: .touchUpInside)
        self.view.addSubview(sureButton)
        
        sureButton.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.height.equalTo(60)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    @objc func addThing(){
        if self.inputThingsName.text==""||self.inputThingsNum.text==""{
            return
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: Notification_ThingsAdded), object: [self.inputThingsName!.text,self.inputThingsNum!.text])
        self.dismiss(animated: true)
    }
    
    @objc func longPress(_ sender:UILongPressGestureRecognizer){
        switch sender.state {
        case .began:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            canReisze = true
        case .ended:
            canReisze = false
        default:
            return
        }
    }
    
    @objc func pan(_ sender:UIPanGestureRecognizer){
        if canReisze {
            let point = sender.translation(in: sender.view)
            var height :CGFloat = 0
            let topmax :CGFloat = UIScreen.main.bounds.size.height - NavigationBar_H
            if self.preferredContentSize.height - point.y>600 {
                height = (self.preferredContentSize.height - point.y) > topmax ? topmax : self.preferredContentSize.height - point.y
            }else{
                height = (self.preferredContentSize.height - point.y) < 300 ? 300 : self.preferredContentSize.height - point.y
            }
            sender.setTranslation(CGPoint.init(x: 0, y: 0), in: sender.view)
            self.preferredContentSize = CGSize.init(width: self.view.bounds.size.width, height: height)
        }
    }
    

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
