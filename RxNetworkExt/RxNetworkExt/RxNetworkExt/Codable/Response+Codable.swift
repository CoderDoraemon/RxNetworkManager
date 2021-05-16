//
//  Response+Extension.swift
//  RxNetwork
//
//  Created by LDD on 2019/6/30.
//  Copyright © 2019 文刂Rn. All rights reserved.
//

import RxSwift
import Moya
import CleanJSON

struct Model<T: Codable>: Codable {
    
    let errorCode: Int
    let errorMessage: String
    let result: T
    
    var success: Bool {
        return errorCode == 0
    }
}

public extension Response {
    
    func mapObject<T: Codable>(_ type: T.Type, atKeyPath path: String? = nil, using decoder: JSONDecoder = CleanJSONDecoder(), failsOnEmptyData: Bool = true) throws -> T {
        
        do {
            return try map(type, atKeyPath: path, using: decoder, failsOnEmptyData: failsOnEmptyData)
        } catch {
            throw MoyaError.objectMapping(error, self)
        }
    }
    
    func mapObject<T: Codable>(_ type: T.Type, using decoder: JSONDecoder = CleanJSONDecoder()) throws -> T {
        
        let response = try mapObject(Model<T>.self, atKeyPath: nil, using: decoder)
        if response.success {
            return response.result
        }
        
        throw LDError(code: response.errorCode, reason: response.errorMessage)
    }
}
