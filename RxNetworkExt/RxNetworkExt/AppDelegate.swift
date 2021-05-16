//
//  AppDelegate.swift
//  RxNetworkExt
//
//  Created by LDD on 2019/6/30.
//  Copyright © 2019 LDD. All rights reserved.
//

import UIKit
import Moya

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    
    // MARK: - 初始化网络请求
    func setUpNetwork() {
        
        Network.Configuration.default.timeoutInterval = 20
                Network.Configuration.default.plugins = [NetworkLoggerPlugin(verbose: true)]
        
        Network.Configuration.default.replacingTask = { target in
            
            switch target.task {
            case let .requestParameters(parameters, encoding):
                
                let params: [String: Any] = [
                                             "os": "iOS",
                                             "app": "GSApp",
                                             "appVersion": "3.7.4",
                                             "request": parameters
                ]
                return .requestParameters(parameters: params, encoding: encoding)
            default:
                return target.task
            }
        }
    }
}

