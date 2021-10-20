//
//  ApiResponse.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 19/10/2021.
//

import Foundation

// MARK: - retrieved Books
struct ApiResponse<T: Decodable>: Decodable {
    
    let totalItems: Int?
    let items: T?
}
