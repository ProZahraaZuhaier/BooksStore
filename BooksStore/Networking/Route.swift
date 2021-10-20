//
//  Route.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 19/10/2021.
//

import Foundation

enum Route {
  
    static let baseURL = "https://www.googleapis.com/books/v1/volumes?key=AIzaSyAnPJB32xH9U1CKylidXNPfj0s3Ge-UGos&filter=free-ebooks&printType=books"
    
    case FictionBooks
    case RomanceBooks
    case Sci_Fi_Books
    case CrimeBooks
    
    
    var path: String {
        
        switch self {
     
        case .FictionBooks:
            return "&q=fiction+subject"
        case .RomanceBooks:
            return "&q=romance+subject"
        case .Sci_Fi_Books:
            return "&q=sci-fi+subject"
        case .CrimeBooks:
            return "&q=crime+subject"
        }
}
}
