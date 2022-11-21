//
//  ChartAxisValueFormatter.swift
//  collection
//
//  Created by 张晖 on 2022/6/1.
//

import UIKit
import Charts

class ChartAxisValueFormatter: NSObject,AxisValueFormatter {
    var values:NSArray?;
        override init() {
            super.init();
        }
        init(_ values: NSArray) {
            super.init();
            self.values = values;
        }
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            if values == nil {
                return "\(value)";
            }
            return values?.object(at: Int(value)) as! String;
        }
}
