//
//  NetworkService.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 19/10/2021.
//

import Foundation

struct NetworkService {

    static let shared = NetworkService()
    private init(){}
    
    func fetchBooks(route: Route , method: Method ,completion: @escaping(Result<[BookModel],Error>) -> Void){
        
        makeRequest(route: route, method: method, completion: completion)
    }
    
    //MARK:- This function to generate URL Request
    /// - Parameters:
    ///   - route: the path to the resourses
    ///   - method: type of request
    ///   - parameters: whatever extra information that you need to pass
    /// - Returns: URL Request
    
    private func createURLRequest(route: Route ,
                               method: Method ,
                               parameters: [String:Any]? = nil ) -> URLRequest? {
        
        let urlString = Route.baseURL + route.path
        
        let url = URL(string: urlString)
        
        guard let _ = url  else {return nil}
        
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpMethod = method.rawValue
        
        if let params = parameters {
            switch method {
            
            case .get:
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = params.map {URLQueryItem(name: $0, value: "\($1)")}
                urlRequest.url = urlComponent?.url
            case .post , .delete , .patch :
                let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
                urlRequest.httpBody = bodyData
                
            }
        }
        return urlRequest
    }
    
    
    //MARK:- Make request Method
    
    private func makeRequest<T: Decodable>(route: Route ,
                                           method: Method ,
                                           parameters: [String : Any]? = nil ,
                                           completion: @escaping(Result<T,Error>) -> Void) {
        
        guard let request = createURLRequest(route: route, method: method, parameters: parameters) else {
            
            completion(.failure(ErrorHandler.unknownError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            var result: Result<Data , Error>?
            
            if let data = data {
                result = .success(data)
                let responseString = String(data: data , encoding: .utf8) ??  " Could not stringify data"
//                print(responseString)
                
            }
            else if let error = error {
                result = .failure(error)
                print("the error is: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                
                //TODO:- handle response
                self.handleResponse(result: result, completion: completion)
                
            }
            
        }.resume()
        
    }
    
    //MARK:- Handle Response Method
    private func handleResponse<T: Decodable>(result: Result<Data , Error>? ,
                                              completion: (Result<T , Error>) -> Void) {
    
        guard let result = result else {
            completion(.failure(ErrorHandler.unknownError))
            return
        }
        
        switch result {
        
        case .success(let data):
            let decoder = JSONDecoder()
            guard let response = try? decoder.decode(ApiResponse<T>.self, from: data) else {
                completion(.failure(ErrorHandler.errorDecoding))
                return
            }
      
            if let decodedData = response.items {
                completion(.success(decodedData))
            }
            else{
                completion(.failure(ErrorHandler.errorDecoding))
            }
        
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
