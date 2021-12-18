//
//  NetworkService.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 12/12/2021.
//

import Foundation
import Alamofire

class NetworkService {
    
    static let shared = NetworkService()
    private init(){}
    
    func fetchBooks(route: TargetType , method: Method ,completion: @escaping(Result<[BookModel],Error>) -> Void){
        
        fetchData(target: route, method: method , completion: completion)
           
        }
    
    func fetchSearchResults (searchKeyword:String , completion: @escaping(Result<[BookModel],Error>) -> Void) {
        searchBooksRequest(searchKeyword: searchKeyword, completion: completion)
    }
//MARK: - Main fuction to handle request
func fetchData<T: Decodable>(target : TargetType ,method: Method, completion:@escaping (Result<T,Error>) -> Void) {
        let method = Alamofire.HTTPMethod(rawValue: method.rawValue)

        AF.request(TargetType.baseURL + target.path , method: method)
            .responseJSON { response in
                guard let statusCode = response.response?.statusCode else {
                    //ADD Custom Error
                    completion(.failure(ErrorHandler.invalidURL))
                    return
                }
                if statusCode == 200 {
                    //Successful request
                    var result : Result<Data , Error>?
                    if let data = response.data {
                        result = .success(data)
                    }
                    
                    else if let error = response.error {
                        result = .failure(error)
                    }
                   
                        
                    // handle response
                    DispatchQueue.main.async {
                        self.handleResponse(result: result, completion: completion)
                    }
                }
                
                else {
                    //ADD Custom Error based on status code 404,401...etc
                    completion(.failure(ErrorHandler.unknownError))
                }
            }
}
    
//MARK: - Handle Response Method
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
//MARK: - Search Api
extension NetworkService {
 func searchBooksRequest<T:Decodable>(searchKeyword:String , completion: @escaping (Result<T , Error>) -> Void){
     AF.request("https://www.googleapis.com/books/v1/volumes?q=\(searchKeyword)&key=AIzaSyAnPJB32xH9U1CKylidXNPfj0s3Ge-UGos&filter=free-ebooks&printType=books&orderBy=newest")
         .responseJSON { response in
             guard let statusCode = response.response?.statusCode else {
                 //ADD Custom Error
                 completion(.failure(ErrorHandler.invalidURL))
                 return
             }
             if statusCode == 200 {
                 //Successful request
                 var result : Result<Data , Error>?
                 if let data = response.data {
                     result = .success(data)
                 }
                 
                 else if let error = response.error {
                     result = .failure(error)
                 }
    
                     // handle response
                 DispatchQueue.main.async {
                     self.handleResponse(result: result, completion: completion)
                 }
                     
             }
             else {
                 //ADD Custom Error based on status code 404,401...etc
                 completion(.failure(ErrorHandler.unknownError))
             }
         }
}
}
