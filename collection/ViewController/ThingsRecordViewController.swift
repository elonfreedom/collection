//
//  ThingsRecordViewController.swift
//  collection
//
//  Created by 张晖 on 2022/5/31.
//

import UIKit
import Charts

class ThingsRecordViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate {
    
    var currentThing:Realm_Thing!
    var chartView: LineChartView!

    lazy var tableView:UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        table.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        table .register(UINib.init(nibName: "RecordTableViewCell", bundle: nil), forCellReuseIdentifier: "RecordTableViewCellId")
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredContentSizeWithTraitCollection(traitCollection: self.traitCollection)
        configureChartsView()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.chartView.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.scrollToRow(at: IndexPath.init(row: self.currentThing.records.count-1, section: 0), at: .bottom, animated: true)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        updatePreferredContentSizeWithTraitCollection(traitCollection: newCollection)
    }
    
    func updatePreferredContentSizeWithTraitCollection(traitCollection:UITraitCollection){
        self.preferredContentSize = CGSize.init(width: self.view.bounds.size.width, height: traitCollection.verticalSizeClass == .compact ?270:620)
    }
    
    func configureChartsView(){
        //创建折线图组件对象
        chartView = {
            $0.noDataText = "暂无统计数据" //无数据的时候显示
            $0.chartDescription.enabled = false //是否显示描述
            $0.scaleXEnabled = false
            $0.scaleYEnabled = false
            $0.leftAxis.drawGridLinesEnabled = false
            $0.leftAxis.drawAxisLineEnabled = true
            $0.xAxis.drawGridLinesEnabled = false
            $0.rightAxis.drawGridLinesEnabled = false
            $0.rightAxis.drawAxisLineEnabled = false
            $0.rightAxis.enabled = false
            $0.legend.enabled = false
            $0.leftAxis.granularity = 1
            $0.rightAxis.drawZeroLineEnabled = true
            $0.xAxis.spaceMin = 0.01
            $0.xAxis.axisLineColor = UIColor(named: "lineColor")!
            $0.leftAxis.axisLineColor = UIColor(named: "lineColor")!
            $0.xAxis.labelPosition = .bottom
            return $0
        }(LineChartView())
        self.view.addSubview(chartView)
        
        chartView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-14)
            make.top.equalToSuperview().offset(40)
            make.height.equalTo(120)
        }
         
        var dataEntries = [ChartDataEntry]()
        let titleArray:NSMutableArray = NSMutableArray.init()
        for i in 0..<self.currentThing.records.count{
            let record = self.currentThing.records[i]
            let entry = ChartDataEntry.init(x: Double(i), y: Double(record.currentNum) )
            dataEntries.append(entry)
            titleArray.add(record.date.date2String("MM-dd"))
        }
        chartView.xAxis.valueFormatter = ChartAxisValueFormatter.init(titleArray)
        chartView.xAxis.granularity = ceil(Double(titleArray.count/4))==0 ? 1 : ceil(Double(titleArray.count/4))
        let chartDataSet = LineChartDataSet(entries: dataEntries)
        chartDataSet.highlightEnabled = false
        chartDataSet.drawFilledEnabled = true //开启填充色绘制
        chartDataSet.fillColor = .orange  //设置填充色
        chartDataSet.fillAlpha = 0.5 //设置填充色透明度
        chartDataSet.drawFilledEnabled = true
        chartDataSet.circleRadius = 1.0
        chartDataSet.circleHoleRadius = 1.0
//        chartDataSet.circleColors = [UIColor(named: "yellowCell")]
        chartDataSet.circleColors = [UIColor(named: "lineColor")!]
        chartDataSet.colors = [UIColor(named: "lineColor")!]
        chartDataSet.mode = .stepped
        chartDataSet.drawValuesEnabled = true//是否在拐点处显示数据
        chartDataSet.valueColors = [UIColor(named: "lineColor")!,UIColor(named: "lineColor")!]//折线拐点处显示数据的颜色
        chartDataSet.drawCirclesEnabled = false//是否开启绘制阶梯样式的折线图
        chartDataSet.cubicIntensity = 0.2// 曲线弧度
//        chartDataSet.circleRadius = 3.0//拐点半径
        //渐变颜色数组
        let gradientColors = [UIColor(named: "yellowCell")!.cgColor, UIColor.white.cgColor] as CFArray
        //每组颜色所在位置（范围0~1)
        let colorLocations:[CGFloat] = [1.0, 0.0]
        //生成渐变色
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                       colors: gradientColors, locations: colorLocations)
        //将渐变色作为填充对象s
        chartDataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90.0)
        //不显示图例头部
        chartView.legend.form = .none
        //目前折线图只包括1根折线
        let chartData = LineChartData(dataSets: [chartDataSet])
        //设置折现图数据
        chartView.data = chartData
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentThing.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record:Realm_ThingRecord = currentThing.records[indexPath.row]
        let cell:RecordTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCellId") as! RecordTableViewCell)
        cell?.backView.backgroundColor = UIColor(named: "yellowCell")
        cell?.backgroundColor = UIColor.clear
        cell?.lblOperateState.text = (OperateState(rawValue: record.state)?.zh_CN_String ?? "操作")+"  \(record.changeNum)单位"
        cell?.lblTime.text = record.date.date2String("yyyy-MM-dd")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
