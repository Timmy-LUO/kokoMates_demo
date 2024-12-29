//
//  HttpTargetType.swift
//  travel-interview
//
//  Created by ZHI on 2024/11/20.
//

import Alamofire
import Foundation

public enum HttpResponse<SuccessBody: Decodable, FailureBody: Decodable> {
    case success(SuccessBody)
    case failure(FailureBody)
}

public enum TokenType {
    case none
    case user
}

public enum CachePolicy {
    case ignore
    case useCache
}

public enum LogPolicy {
    case title
    case complete
    case ignore
}

public protocol HttpTargetType {
    associatedtype SuccessType: Decodable
    associatedtype FailureType: Decodable
    
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var parameterEncoding: ParameterEncoding { get }
    var tokenType: TokenType { get }
}

public extension HttpTargetType {
    var baseURL: URL { HttpApiConfig.baseURL }
    var headers: HTTPHeaders? { nil }
    var parameters: Parameters? { nil }
    var parameterEncoding: ParameterEncoding { URLEncoding.default }
    var tokenType: TokenType { .none }
    var cachePolicy: CachePolicy { .ignore }
    var logPolicy: LogPolicy { .complete }
    
    func request(completion: @escaping (Result<HttpResponse<SuccessType, FailureType>, Error>) -> Void) {
        let url = baseURL.appendingPathComponent(path)
        
        var requestHeaders = headers ?? HTTPHeaders()
        requestHeaders.add(name: "Accept", value: "application/json")
//        if tokenType == .user, let token = fetchUserToken() {
//            requestHeaders.add(.authorization(bearerToken: token))
//        }
        
        AF.request(
            url,
            method: method,
            parameters: parameters,
            encoding: parameterEncoding,
            headers: requestHeaders
        )
        .validate()
        .responseDecodable(of: SuccessType.self, decoder: jsonDecoder) { response in
            switch response.result {
            case .success(let successBody):
                completion(.success(.success(successBody)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
    
//    private func fetchUserToken() -> String? {
//        return "your_user_token_here"
//    }
}
