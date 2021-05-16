//
//  Network+Rx.swift
//  RxNetwork_Example
//
//  Created by GorXion on 2018/5/28.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import RxNetwork
import HandyJSON

extension Network {
    
    struct Response<T: Codable>: Codable {
        
        let errorCode: Int
        let errorMessage: String
        let result: T
        
        
        var success: Bool {
            return errorCode == 0
        }
        
        enum CodingKeys: String, CodingKey {
            case errorCode
            case errorMessage
            case result
        }
    }
    
    struct ApiModel: HandyJSON {
        
        var errorCode: Int = 0
        var errorMessage: String = ""
        var result: Any?
        
        var success: Bool {
            return errorCode == 0
        }
    }
}

extension Network {
    
    enum HttpStatus: Int {
        /** 初始化code */
        case none = 0
        /** 请求失败 */
        case requestFailed = 1
        /** 请求成功 */
        case success = 200
        /** 解析失败错误 */
        case dataParseFailed = 301
        /** 数据类型错误 */
        case dataTypeError = 302
        /** token过期 */
        case tokenOverdue = 1001
        /** token无效 */
        case tokenNull = 1002
        /** 强迫下线 */
        case tokenForce = 1003
    }
    
    enum Error: Swift.Error {
        case status(code: Int, message: String)
        
        var code: Int {
            switch self {
            case .status(let code, _):
                return code
            }
        }
        
        var message: String {
            switch self {
            case .status(_, let message):
                return message
            }
        }
    }
    
    
}
