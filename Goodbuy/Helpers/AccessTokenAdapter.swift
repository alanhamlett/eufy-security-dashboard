//
//  AccessTokenAdapter.swift
//  Hotline
//
//  Created by James Mudgett on 2/9/20.
//  Copyright © 2020 Heavy Technologies, Inc. All rights reserved.
//

//import Foundation
//import Alamofire
//
//final class AccessTokenAdapter: RequestInterceptor {
//    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
//        var adaptedRequest = urlRequest
//        guard let token = UserManager.current.accessToken else {
//            completion(.success(adaptedRequest))
//            return
//        }
//        
//        adaptedRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        completion(.success(adaptedRequest))
//    }
//    
//    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
//            //get token
//        }
//    }
//}
