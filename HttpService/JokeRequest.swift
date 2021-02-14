//
//  JokeRequest.swift
//  HttpRequest
//
//  Created by Umezawa Keisuke on 2021/02/14.
//

import Foundation
import Alamofire

struct JokeRequest: BaseRequestProtocol {
    typealias ResponseType = JokeRequestResponse

    var method: HTTPMethod {
        return .get
    }

    var path: String? {
        APIConstants.joke.path
    }

    var parameters: Parameters? {
        return nil
    }

}


struct JokeRequestResponse: Codable {
    let slip: Joke
}

struct Joke: Codable {
    let id: Int
    let advice: String
}
