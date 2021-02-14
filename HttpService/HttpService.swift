//
//  HttpService.swift
//  HttpRequest
//
//  Created by Umezawa Keisuke on 2021/02/14.
//

import Foundation
import Alamofire

class HttpClientService {

    // MARK: Private Static Variables
    private static let successRange = 200..<600
    private static let contentType = ["application/json"]


    static func call<T>(request: T, handlerSuccess: ((DataResponse<Data>) -> Void)? = nil) -> ()
    where T: BaseRequestProtocol
    {
        callRequest(request: request) { result in
            switch result {
            case .success(let value):
                let model = decodeJson(response: value, objectType: T.ResponseType.self)
                print(model)
            case .failure(let error):
                print(error)
            }
        }
    }

    private static func callRequest<T>(request: T, completion: @escaping (Result<DataResponse<String>>) -> Void)
    where T: BaseRequestProtocol {
        alamofire(request: request)
            .responseString { response in
                switch (response).result {
                case .success(_): completion(.success(response))
                case .failure(let error): completion(.failure(error))
                }
        }
    }

    private static func alamofire<T>(request: T) -> DataRequest
    where T: BaseRequestProtocol {
        return Alamofire
            .request(request)
            .validate(statusCode: successRange)
            .validate(contentType: contentType)
    }

    private static func decodeJson<T>(response: DataResponse<String>, objectType: T.Type = T.self) -> T
    where T: Codable {
        do {
            let jsonData = response.data!
            let decoder: JSONDecoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let model = try decoder.decode(T.self, from: jsonData)
            return model
        } catch(let error) {
            print(error)
            fatalError()
        }
    }

}
