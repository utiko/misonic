//
//  BaseRequest.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/4/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation
import Alamofire

public typealias RequestEncoding = ParameterEncoding

protocol BaseRequestProtocol {
    func data() -> Data?
    func httpMethod() -> HTTPMethod
    func apiMethod() -> String
    func parameters() -> [String: Any]
    func headers() -> [String: String]
    func encoding() -> RequestEncoding
    func successCodes() -> [Int]
    
    func requestCompleted(_ data: Data)
    func requestCompletedWithServerError(_ errorData: Data)
    func requestCompleted(_ error: Error)
}

enum ResponseType<T, E> {
    case success(T)
    case successWithError(E)
    case error(Error?)
}

class BaseRequest<T: Decodable, E: Decodable>: NSObject, BaseRequestProtocol {
    typealias ResultType = T
    typealias ErrorType = E

    func requestCompleted(_ data: Data) {
        do {
            let object = try JSONDecoder().decode(ResultType.self, from: data)
            completion(ResponseType.success(object))
        } catch {
            completion(ResponseType.error(error))
        }
    }
    
    func requestCompletedWithServerError(_ errorData: Data) {
        do {
            let error = try JSONDecoder().decode(ErrorType.self, from: errorData)
            completion(ResponseType.successWithError(error))
        } catch {
            completion(ResponseType.error(error))
        }
    }
    
    func requestCompleted(_ error: Error) {
        completion(ResponseType.error(error))
    }
    
    var defaultHeaders: [String: String] {
        var headers: [String: String] = [:]
        
        var currentDeviceLanguage = "en"
        if let language = Locale.current.languageCode {
            currentDeviceLanguage = language
        }
        
        headers["Accept-Language"] =  currentDeviceLanguage
        headers["Content-Type"] = "application/json"

//        No authorization needed
//        headers["Authorization"] =
        
        return headers
    }
    
    var completion: (ResponseType<T, E>) -> Void
    
    init(completionClosure: @escaping (_ response: ResponseType<T, E>) -> Void) {
        completion = completionClosure
    }
    
    func successCodes() -> [Int] {
        return [200]
    }
    
    func httpMethod() -> HTTPMethod {
        return .get
    }
    
    func data() -> Data? {
        return nil
    }
    
    func apiMethod() -> String {
        fatalError("Should be overrided")
    }
    
    func parameters() -> [String: Any] {
        return [
            "method": apiMethod(),
            "api_key": NetworkingConfiguration.shared.apiKey,
            "format": "json"
        ]
    }
    
    func encoding() -> RequestEncoding {
        return URLEncoding.default
    }
    
    func headers() -> [String: String] {
        return [:]
    }
    
    func perform() {
        APIService.service.performRequest(self)
    }
}
