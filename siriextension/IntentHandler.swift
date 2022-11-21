//
//  IntentHandler.swift
//  siriextension
//
//  Created by 张晖 on 2022/5/25.
//

import Intents
import os.log

class IntentHandler: INExtension{
    
    override func handler(for intent: INIntent) -> Any {
        os_log("TK421: IntentHandler called!")
        guard intent is ThingsWhereIntent else {
            fatalError("Unhandled Intent error : \(intent)")
        }
        return ThingsWhereIntentHandle()
    }
}
