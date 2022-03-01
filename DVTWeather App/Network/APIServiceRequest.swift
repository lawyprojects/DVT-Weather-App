//
//  APIServiceRequest.swift
//  DVTWeather App
//
//  Created by Lawrence Magerer on 25/02/2022.
//

import Foundation

// MARK: - HTTP Methods
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

// MARK: - HTTP Header

struct Header {
    let field: String
    let value: String
}

struct APIServiceRequest {
    let method: HTTPMethod
    var path: String?
    var queryItems: [String: Any]?
    var headers: [Header]?
    var body: Data?
    
    init(method: HTTPMethod) {
        self.method = method
    }

    init(method: HTTPMethod, path: String, queryItems: [String: Any]) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
    }
    
    init<Body: Encodable>(method: HTTPMethod, path: String, body: Body) throws {
        self.method = method
        self.path = path
        self.body = try? JSONEncoder().encode(body)
    }
}
