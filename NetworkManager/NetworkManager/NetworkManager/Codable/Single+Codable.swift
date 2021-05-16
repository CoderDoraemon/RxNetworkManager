//
//  RxNetwork+Demo.swift
//  RxNetwork_Example
//
//  Created by GorXion on 2018/7/18.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Moya
import RxSwift
import CleanJSON
import HandyJSON
import RxNetwork

/// 解挡/归档
public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    /// 解挡、归档转模型
    ///
    /// - Parameters:
    ///   - type: 需要转的类型
    ///   - path: 路径
    ///   - decoder: 解挡对象
    ///   - failsOnEmptyData: 失败返回空对象
    /// - Returns: 模型
    func mapObject<T: Codable>(_ type: T.Type, atKeyPath path: String? = nil, using decoder: JSONDecoder = CleanJSONDecoder()) -> Single<T> {
        return map {
            
            guard let response = try? $0.mapObject(type, atKeyPath: path, using: decoder, failsOnEmptyData: true) else {
                throw MoyaError.jsonMapping($0)
            }
            return response
        }
    }
}
/// HandyJSON
public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    /// HandyJSON转模型
    ///
    /// - Parameters:
    ///   - type: 需要转的类型
    ///   - path: 路径
    /// - Returns: 模型
    func mapModel<T: HandyJSON>(_ type: T.Type, atKeyPath path: String? = nil) -> Single<T> {
        
        return map {
            
            guard let response = try? $0.mapModel(type, atKeyPath: path) else {
                throw MoyaError.jsonMapping($0)
            }
            return response
        }
    }
    
    func mapList<T: HandyJSON>(_ type: T.Type, atKeyPath path: String? = nil) -> Single<[T]> {
        
        return map {
            
            guard let response = try? $0.mapList(type, atKeyPath: path) else {
                throw MoyaError.jsonMapping($0)
            }
            return response
        }
    }
}

public extension ObservableType where E == Response {
    
    func mapObject<T: Codable>(_ type: T.Type) -> Observable<T> {
        return map { try $0.mapObject(type) }
    }
}

public extension ObservableType where E == Response {
    
    func mapModel<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
        
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapModel(T.self))
        }
    }
}
