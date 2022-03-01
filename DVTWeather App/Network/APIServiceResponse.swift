//
//  APIServiceResponse.swift
//  DVTWeather App
//
//  Created by Lawrence Magerer on 25/02/2022.
//

import Foundation

//MARK: APIServiceResult
enum APIServiceResult<Body> {
    case success(APIServiceResponse<Body>)
    case failure(Error)
}

//MARK: APIResponse
struct APIServiceResponse<Body> {
    
    let statusCode: Int
    let body: Body?
    
    
    func decode<T: Decodable>(to type: T.Type) throws -> APIServiceResponse<T> {
        guard let data = body else {
            throw Error.dataError
        }
     
        guard let decodedJSON = try? JSONDecoder().decode(T.self, from: data as! Data) else {
            throw Error.decodingError
        }
        
        return APIServiceResponse<T>(statusCode: self.statusCode, body: decodedJSON)
    }
    
}

// MARK: APIServiceResponse - Error
enum Error: LocalizedError {
    case invalidURL
    case requestError
    case networkError
    case decodingError
    case dataError
    
    public var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid Url"
        case .requestError:
            return "Request Failed"
        case .networkError:
            return "Connection Error"
        case .decodingError:
            return "Error decoding response"
        case .dataError:
            return "Invalid response"
        }
    }
}

