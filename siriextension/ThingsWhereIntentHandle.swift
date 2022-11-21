//
//  ThingsWhereIntentHandle.swift
//  siriextension
//
//  Created by 张晖 on 2022/5/30.
//

import UIKit
import Intents
import os.log

class ThingsWhereIntentHandle: NSObject,ThingsWhereIntentHandling{
    func confirm(intent: ThingsWhereIntent, completion: @escaping (ThingsWhereIntentResponse) -> Void) {
        os_log("TK421: %{public}s", "\(#function)")
        completion(ThingsWhereIntentResponse(code: .ready, userActivity: nil))
    }
    
    func handle(intent: ThingsWhereIntent, completion: @escaping (ThingsWhereIntentResponse) -> Void) {
        os_log("TK421: %{public}s", "\(#function)")
        completion(ThingsWhereIntentResponse.success(amount:"$34.56"))
    }

//    func resolveHoder(for intent: ThingsWhereIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
//        if intent.hoder == "hoder" {
//            completion(INStringResolutionResult.needsValue())
//        }else{
//            completion(INStringResolutionResult.success(with: intent.hoder ?? ""))
//        }
//    }
    
//    func handle(intent: PersonInfoIntent, completion: @escaping (PersonInfoIntentResponse) -> Void) {
//        print(intent.firstName!)
//        completion(PersonInfoIntentResponse.success(result: "Successfully"))
//    }
//
//    func resolveFirstName(for intent: PersonInfoIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
//        if intent.firstName == "firstName" {
//            completion(INStringResolutionResult.needsValue())
//        }else{
//            completion(INStringResolutionResult.success(with: intent.firstName ?? ""))
//        }
//    }
}
