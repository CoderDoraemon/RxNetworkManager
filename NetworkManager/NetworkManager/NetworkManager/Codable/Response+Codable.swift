//
//  Response+Demo.swift
//  RxNetwork_Example
//
//  Created by GorXion on 2018/7/18.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Moya
import RxNetwork
import CleanJSON
import HandyJSON

public extension Response {
    
    /// 解挡、归档转模型
    ///
    /// - Parameters:
    ///   - type: 需要转的类型
    ///   - path: 路径
    ///   - decoder: 解挡对象
    ///   - failsOnEmptyData: 失败返回空对象
    /// - Returns: 模型
    /// - Throws: 异常抛出
    func mapObject<T: Codable>(_ type: T.Type, atKeyPath path: String? = nil, using decoder: JSONDecoder = CleanJSONDecoder(), failsOnEmptyData: Bool = true) throws -> T {
        
        let response = try map(Network.Response<T>.self, atKeyPath: path, using: decoder, failsOnEmptyData: failsOnEmptyData)
        if response.success { return response.result }
        throw Network.Error.status(code: response.errorCode, message: response.errorMessage)
    }
    
}

/// HandyJSON
extension Response {
    
    /// HandyJSON转模型
    ///
    /// - Parameters:
    ///   - type: 需要转的类型
    ///   - path: 路径
    /// - Returns: 模型
    /// - Throws: 异常抛出
    func mapModel<T: HandyJSON>(_ type: T.Type, atKeyPath path: String? = nil) throws -> T {
        
        guard let baseModel = Network.ApiModel.deserialize(from: try mapString()),
            baseModel.success else {
                throw Network.Error.status(code: Network.HttpStatus.requestFailed.hashValue, message: "请求失败")
        }
        
        guard let dict = baseModel.result as? [String: Any] else {
            throw Network.Error.status(code: Network.HttpStatus.dataTypeError.hashValue, message: "数据类型错误")
        }
        
        guard let model = T.deserialize(from: dict, designatedPath: path) else {
            throw Network.Error.status(code: Network.HttpStatus.dataTypeError.hashValue, message: "数据解析失败")
        }
        
        return model
    }
    
    func mapList<T: HandyJSON>(_ type: T.Type, atKeyPath path: String? = nil) throws -> [T] {
        
        guard let baseModel = JSONDeserializer<Network.ApiModel>.deserializeFrom(json: try mapString()),
            baseModel.success else {
                throw Network.Error.status(code: Network.HttpStatus.requestFailed.hashValue, message: "请求失败")
        }
        
        if let jsonArray = baseModel.result {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray, options: []),
                let jsonString = String.init(data: jsonData, encoding: .utf8),
                let modelArray = [T].deserialize(from: jsonString, designatedPath: path) else {
                    throw Network.Error.status(code: Network.HttpStatus.dataTypeError.hashValue, message: "数据解析失败")
            }
            
            let result = modelArray.compactMap({ $0 })
            
            return result
        } else {
            return []
        }
    }
    
}

