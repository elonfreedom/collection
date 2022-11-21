//
//  ChooseNumberViewController.swift
//  collection
//
//  Created by 张晖 on 2022/6/2.
//

import UIKit

protocol choooseNumDelegate {//第一步 定义协议
    func changeNum(NewNum: Int)
}

class ChooseNumberViewController: BaseViewController,UIViewControllerTransitioningDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    var maxNum:Int?
    let pickerView = UIPickerView()
    var delegate: choooseNumDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredContentSizeWithTraitCollection(traitCollection: self.traitCollection)
        configurePickView()
        // Do any additional setup after loading the view.
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        updatePreferredContentSizeWithTraitCollection(traitCollection: newCollection)
    }
    
    func updatePreferredContentSizeWithTraitCollection(traitCollection:UITraitCollection){
        self.preferredContentSize = CGSize.init(width: self.view.bounds.size.width, height: traitCollection.verticalSizeClass == .compact ?270:400)
    }
    
    func configurePickView(){
        let lblTitle = UILabel()
        lblTitle.text = "选择数量"
        lblTitle.textAlignment = .center
        lblTitle.font = UIFont.boldSystemFont(ofSize: 20)
        self.view.addSubview(lblTitle)
        
        lblTitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(10)
            make.height.equalTo(40)
        }
        
        pickerView.dataSource = self
        pickerView.delegate = self
        //设置选择框的默认值
        pickerView.selectRow(0,inComponent:0,animated:true)
        self.view.addSubview(pickerView)
        
        pickerView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-100)
            make.top.equalToSuperview().offset(60)
        }
        
        let sureButton = UIButton()
        sureButton.setTitle("确定", for: .normal)
        sureButton.backgroundColor = UIColor(named: "yellowCell")
        sureButton.layer.cornerRadius = 10
        sureButton.layer.masksToBounds = true
        sureButton.setTitleColor(UIColor(named: "normalText"), for: .normal)
        sureButton.addTarget(self, action: #selector(sure), for: .touchUpInside)
        self.view.addSubview(sureButton)
        
        sureButton.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.height.greaterThanOrEqualTo(60)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return  self.maxNum ?? 30
    }
    //设置选择框各选项的内容，继承于UIPickerViewDelegate协议
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return String(row+1)
    }

    @objc func sure(){
        self.delegate?.changeNum(NewNum: pickerView.selectedRow(inComponent: 0)+1)
        self.dismiss(animated: true)
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
