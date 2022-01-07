//
//  BookModel.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 19/10/2021.
//

import Foundation

// MARK: - Item
struct  BookModel : Codable  {
    //Book Info
    let volumeInfo: VolumeInfo?
    }
// MARK: - Book Info
struct VolumeInfo : Codable {
    let id: String?
    let title: String?
    let authors: [String]?
    let publishedDate: String?
    let imageLinks: ImageLinks?
    let previewLink: String?
    let language:String?
    let pageCount: Int?
    let categories: [String]?
    let description: String?
}
// MARK: - ImageLinks
 struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String?
}
