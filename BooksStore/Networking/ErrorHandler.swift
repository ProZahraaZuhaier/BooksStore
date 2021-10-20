//
//  ErrorHandler.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 20/10/2021.
//

import Foundation

enum ErrorHandler : Error{
    case errorDecoding
    case unknownError
    case invalidURL
    case serverError(String)
    
    var error: String?{
        switch self {
       
        case .errorDecoding:
            return "Response could not be decoded"
        case .unknownError:
            return "Unknown Error"
        case .invalidURL:
            return " Invalid URL , try again with valid URL"
        case .serverError(let error):
            return error
        }
    }
}
