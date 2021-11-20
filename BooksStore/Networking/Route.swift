//
//  Route.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 19/10/2021.
//

import Foundation

enum Route {
  
    static let baseURL = "https://www.googleapis.com/books/v1/volumes?key=AIzaSyAnPJB32xH9U1CKylidXNPfj0s3Ge-UGos&filter=free-ebooks&printType=books&orderBy=newest"
    
    case FictionBooksApi
    case RomanceBooksApi
    case Drama_BooksApi
    case CrimeBooksApi
    
    
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
        }
}
}

