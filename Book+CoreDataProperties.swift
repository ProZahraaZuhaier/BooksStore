//
//  Book+CoreDataProperties.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 30/11/2021.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var isDownloaded: Bool
    @NSManaged public var bookID: String?
    @NSManaged public var bookTitle: String?
    @NSManaged public var authorName: String?
    @NSManaged public var bookImage: String?
    @NSManaged public var publishedDate: String?
    @NSManaged public var progressView: String?
    @NSManaged public var bookPath: String?

}

extension Book : Identifiable {

}
