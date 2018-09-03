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

enum ResponseType<T> {
    case success(T)
    case errorResponse(ErrorResponse)
    case error(Error?)
}

class LastFMBaseRequest<T: Decodable>: NSObject, BaseRequestProtocol {
    typealias ResultType = T
    
    private var completion: (ResponseType<T>) -> Void
    
    init(completion: @escaping (_ response: ResponseType<T>) -> Void) {
        self.completion = completion
    }

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
    
    func successCodes() -> [Int] {
        return [200]
    }
    
    func httpMethod() -> HTTPMethod {
        return .get
    }
    
    func apiMethod() -> String {
        fatalError("Should be overrided")
    }
    
    func parameters() -> [String: Any] {
        return [
            LastFMConstants.RequiredFields.apiMethod: apiMethod(),
            LastFMConstants.RequiredFields.apiKey: NetworkingConfiguration.shared.apiKey,
            LastFMConstants.RequiredFields.format: "json"
        ]
    }
    
    func encoding() -> RequestEncoding {
        return URLEncoding.default
    }
    
    func headers() -> HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Accept-Language", value: Locale.current.languageCode ?? "en")
        headers.add(name: "Content-Type", value: "application/json") 
        return headers
    }
    
    func perform() {
        APIService.service.performRequest(self)
    }
}

struct LastFMConstants {
    struct RequiredFields {
        static let apiMethod = "method"
        static let apiKey = "api_key"
        static let format = "format"
    }
}
