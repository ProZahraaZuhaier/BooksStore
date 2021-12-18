//
//  RealmViewModel.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 18/12/2021.
//

import Foundation
import RealmSwift


protocol RealmDBProtocol {
    func fetchBooks(books: [Book])
    func fetchReadingTime(readingTime: String)
}

class RealmViewModel {
    
    //MARK: - Variables and properties
    var bookInfo: BookModel?
    var books:[Book] = []
    var isDownloaded:Bool = false
    var bookPath: String?
    var bookURL : URL?
    var readingTime = "00 : 00 : 00"
    var bookReader = BookReader()
    var booksDelegate : RealmDBProtocol?
    
    //MARK: - check if the Book is already exist on the Realm DB
    func check(bookData: BookModel )-> Bool {
        self.bookInfo = bookData
        let bookTitle = bookInfo?.volumeInfo?.title
        var status = false
        let realm = try! Realm()
        let results = realm.objects(Book.self).filter(NSPredicate(format: "bookTitle = %@", bookTitle!))
        for result in results {
            if result.bookTitle == bookTitle {
                status = true
                return status
            }
            else {
                return status
            }
        }
        return status
    }
    //MARK: - Save Book information to the Realm DB
    func saveBookInfo(downloadState: Bool ,bookData: BookModel ,bookURL : URL){
        self.bookInfo = bookData
        self.isDownloaded = downloadState
        self.bookURL = bookURL
        let realm = try! Realm()
        let book = Book()
        if check(bookData: self.bookInfo!) == true {
            print("book is already exist")
        }
        else {
            book.isDownloaded = self.isDownloaded
            book.bookPath = self.bookURL?.path ?? ""
            book.bookID = self.bookInfo?.volumeInfo?.id ?? "UnAvailable"
            book.bookTitle = self.bookInfo?.volumeInfo?.title! ?? ""
            book.authorName = self.bookInfo?.volumeInfo?.authors?[0] ?? "Unknown author"
            book.bookImage = self.bookInfo?.volumeInfo?.imageLinks?.thumbnail! ?? ""
            book.publishedDate = self.bookInfo?.volumeInfo?.publishedDate! ?? "UnKnown"
            
            try! realm.write({
                realm.add(book)
                print("book info saved")
            })
        }
    }
    //MARK: - Open the book from the the Realm DB
    func openBook(bookData: BookModel , parentViewController: UIViewController){
        self.bookInfo = bookData
        let realm = try! Realm()
        let results = realm.objects(Book.self).toArray(type: Book.self)
        self.books = results
        for result in results {
            if result.bookTitle == self.bookInfo?.volumeInfo?.title {
                self.bookPath = result.bookPath
                self.bookReader.open(epub: bookPath!, parentViewController: parentViewController)
            }
            
        }
    }
}
//MARK: - Fetch Data from Realm DB
extension RealmViewModel {
    
    //Fetch all books on Realm DB
    func fetchBooks(){
        let realm = try! Realm()
        let results = realm.objects(Book.self).toArray(type: Book.self)
        self.booksDelegate?.fetchBooks(books: results)
    }
    
    // Fetch readingTime from Realm DB
    func fetchReadingTime(){
        let realm = try! Realm()
        let results = realm.objects(TimeTracker.self).toArray(type: TimeTracker.self)
        if results.count == 0 {
            print("time is 0")
        }
        else {
            self.booksDelegate?.fetchReadingTime(readingTime: results.first?.readingTime ?? self.readingTime)
        }
    }
}
