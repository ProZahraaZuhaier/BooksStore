//
//  TargetType.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 12/12/2021.
//

import Foundation
import Alamofire

enum TargetType {
  
    static let baseURL = "https://www.googleapis.com/books/v1/volumes?key=AIzaSyAnPJB32xH9U1CKylidXNPfj0s3Ge-UGos&filter=free-ebooks&printType=books&orderBy=newest"
   
    static let mockApi = "https://61cd56e27067f600179c5a29.mockapi.io"
    
    case FictionBooksApi
    case RomanceBooksApi
    case Drama_BooksApi
    case CrimeBooksApi
    case general
    
   
    var path: String {
        
        switch self {
     
        case .FictionBooksApi:
            return "&q=fantasy+subject:Fiction"
        case .RomanceBooksApi:
            return "&q=love+intitle:Romance"
        case .Drama_BooksApi:
            return "&q=life+subject:Drama"
        case .CrimeBooksApi:
            return "&q=crime+subject:Crime"
        case  .general:
               return "/books"

        }
}
}
