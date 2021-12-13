//
//  Book.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 13/12/2021.
//

import Foundation
import RealmSwift

class Book: Object{
    @objc dynamic var isDownloaded = false
    @objc dynamic var bookID = ""
    @objc dynamic var bookTitle = ""
    @objc dynamic var authorName = ""
    @objc dynamic var bookImage = ""
    @objc dynamic var publishedDate = ""
    @objc dynamic var progressView = ""
    @objc dynamic var bookPath = ""

}

extension Results {
    func toArray<T>(type: T.Type) -> [T] {
         return compactMap { $0 as? T }
     }
    }

