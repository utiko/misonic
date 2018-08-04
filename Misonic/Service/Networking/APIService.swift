//
//  APIService.swift
//  Misonic
//
//  Created by Kostia Kolesnyk on 8/4/18.
//  Copyright © 2018 Kostia Kolesnyk. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    static let service = APIService()
    
    let versionAPI = "2.0"
    
    public func performRequest(_ requestItem: BaseRequestProtocol) {
        guard let baseUrl = URL(string: NetworkingConfiguration.shared.baseApiPath) else { return }
        
        let requestUrl = baseUrl.appendingPathComponent(versionAPI)
        
        let req = request(requestUrl,
                          method: requestItem.httpMethod(),
                          parameters: requestItem.parameters(),
                          encoding: requestItem.encoding(),
                          headers: requestItem.headers())
        
        req.responseData { (response) in
            debugPrint("STATUS CODE: \(String(describing: response.response?.statusCode))")
            debugPrint("Request: \(req.request?.url?.absoluteString ?? "-")")
            switch response.result {
            case .success(let value):
                if requestItem.successCodes().contains(response.response?.statusCode ?? 0) {
                    requestItem.requestCompleted(value)
                } else {
                    requestItem.requestCompletedWithServerError(value)
                }
            case .failure(let error):
                requestItem.requestCompleted(error)
            }
        }
    }
}
