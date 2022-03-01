//
//  APIService.swift
//  DVTWeather App
//
//  Created by Lawrence Magerer on 25/02/2022.
//

import Foundation

class APIService {
    
    // MARK: - Constants
    let baseUrl = "https://api.openweathermap.org/data/2.5/";
    private static let host = "api.openweathermap.org"
    typealias APIServiceTask = (APIServiceResult<Data?>) -> Void
  
    // MARK: - API SERVICE Request
    public func APIServiceRequest(request: APIServiceRequest,apiServiceTask: @escaping APIServiceTask){
        
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = APIService.host
        urlBuilder.path = request.path!
        
        if let path = request.path {
            urlBuilder.path = path
        }
        
        let queryItems = request.queryItems?.map({
            URLQueryItem(name: $0.key, value: "\($0.value)")
        })
        // Add Query Params to request
        urlBuilder.queryItems = queryItems
        
        URLSession.shared.dataTask(with: urlBuilder.url!) { (data, response, error) in
          
          DispatchQueue.main.async {
              
            guard error == nil else {
                print(Error.requestError)
                apiServiceTask(.failure(.requestError))
              return
            }
              
            guard let httpResponse = response as? HTTPURLResponse else {
                 print(Error.requestError)
                  apiServiceTask(.failure(.requestError))
                  return
            }
            
            guard let data = data else {
                print(Error.dataError)
                apiServiceTask(.failure(.dataError))
              return
            }
            apiServiceTask(.success(APIServiceResponse<Data?>(statusCode: httpResponse.statusCode,
                                                         body: data)))
              
          }
        }.resume()
       
    }
    
    
    
    
}
