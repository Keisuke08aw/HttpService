//
//  BaseAPI.swift
//  HttpRequest
//
//  Created by Umezawa Keisuke on 2021/02/14.
//

import Foundation
import Alamofire

enum APIConstants {
    public static var baseURL = "https://api.adviceslip.com"

    case joke

    public var path: String {
        switch self {
        case .joke: return "/advice"
        }
    }

    public static var header: HTTPHeaders {
        return [
            "Content-Type": "application/json"
        ]
    }

    public static var parameters: Parameters {
        return["":""]
    }
}


protocol BaseAPIProtocol {
    associatedtype ResponseType: Codable

    var method: HTTPMethod { get }
    var baseURL: URL { get }
    var path: String? { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var encoding: URLEncoding { get }
}


extension BaseAPIProtocol {
    var baseURL: URL {
        return try! "https://api.adviceslip.com/advice".asURL()
    }

    var headers: HTTPHeaders? {
        let headers: HTTPHeaders = APIConstants.header
        return headers
    }
    var encoding: URLEncoding {
        return URLEncoding.default
    }
}


protocol BaseRequestProtocol: BaseAPIProtocol, URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

extension BaseRequestProtocol {


    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path!))
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        if method == .get {
            if let params = parameters {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
            }
            return try Alamofire.JSONEncoding.default.encode(urlRequest)
        } else {
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: parameters)
        }
    }
}


