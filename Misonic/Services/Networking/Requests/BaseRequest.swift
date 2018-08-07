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
    func requestCompletedWithErrorResponse(_ errorData: Data)
    func requestCompleted(_ error: Error)
}

enum ResponseType<T> {
    case success(T)
    case errorResponse(ErrorResponse)
    case error(Error?)
}

class BaseRequest<T: Decodable>: NSObject, BaseRequestProtocol {
    typealias ResultType = T

    func requestCompleted(_ data: Data) {
        do {
            let object = try JSONDecoder().decode(ResultType.self, from: data)
            completion(ResponseType.success(object))
        } catch {
            completion(ResponseType.error(error))
        }
    }
    
    func requestCompletedWithErrorResponse(_ errorData: Data) {
        do {
            let error = try JSONDecoder().decode(ErrorResponse.self, from: errorData)
            completion(ResponseType.errorResponse(error))
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
    
    var completion: (ResponseType<T>) -> Void
    
    init(completionClosure: @escaping (_ response: ResponseType<T>) -> Void) {
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
            APIService.Constants.HeaderFields.apiMethod: apiMethod(),
            APIService.Constants.HeaderFields.apiKey: NetworkingConfiguration.shared.apiKey,
            APIService.Constants.HeaderFields.format: "json"
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
