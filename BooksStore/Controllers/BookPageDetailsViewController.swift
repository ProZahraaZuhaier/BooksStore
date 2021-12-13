//
//  BookPageDetailsViewController.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 16/11/2021.
//

import UIKit
import RealmSwift
import FolioReaderKit

class BookPageDetailsViewController: UIViewController, FolioReaderDelegate {
    
    //MARK: - Set Properties & Variables
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var bookInfo: BookModel?
    var bookPath: String?
    var bookURL : URL?
    var isDownloaded:Bool?
    var downloader = DownloadManager()
    var bookPathTest: String?
    var books:[Book] = []
    var bookReader = BookReader()
    var timeManager = TimeManager()
    //MARK: - View Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - Trigger Delegates
        tabelView.delegate = self
        tabelView.dataSource = self
        downloader.downloadStatusDelegate = self
        downloader.saveFileDelegate = self
        //MARK: - Register Cells
        tabelView.register(UINib(nibName: "BookPosterCell", bundle: nil), forCellReuseIdentifier: "BookPosterCell")
        tabelView.register(UINib(nibName: "BookInfoCell", bundle: nil), forCellReuseIdentifier: "BookInfoCell")
        tabelView.register(UINib(nibName: "BookTitleCell", bundle: nil), forCellReuseIdentifier: "BookTitleCell")
        tabelView.register(UINib(nibName: "AuthorNameCell", bundle: nil), forCellReuseIdentifier: "AuthorNameCell")
        tabelView.register(UINib(nibName: "BookCategoriesCell", bundle: nil), forCellReuseIdentifier: "BookCategoriesCell")
        tabelView.register(UINib(nibName: "BookDescriptionCell", bundle: nil), forCellReuseIdentifier: "BookDescriptionCell")
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        //  check if the book is already downloaded or not to change download button label
        if check( bookTitle: bookInfo?.volumeInfo?.title! ?? "") == true {
            DispatchQueue.main.async {
                self.downloadButton.setTitle("Open", for: .normal)
            }
        }
        else {
            DispatchQueue.main.async {
                self.downloadButton.setTitle("Download", for: .normal)
            }
        }
        
        
    }
    //MARK: - Methods
    @IBAction func downloadButtonTapped(_ sender: Any) {
        
        if downloadButton.titleLabel?.text == "Download"{
            //            let bookURL = self.bookInfo?.volumeInfo?.previewLink
            DispatchQueue.main.async {
                self.downloadButton.isEnabled = false
                self.spinner.alpha = 1
                self.spinner.startAnimating()
            }
            // test url
            self.downloader.downloadBook(from: "https://filesamples.com/samples/ebook/epub/Sway.epub")
        }
        else {
            // open the book from the Realm DB
            openBook()
        }
    }
}
//MARK: - Implement download Protocol methods
extension BookPageDetailsViewController : DownloadFileProtocol {
    func didFileDownloaded(status: Bool) {
        self.isDownloaded = status
        if status == true {
            DispatchQueue.main.async {
                self.downloadButton.setTitle("Open", for: .normal)
                self.downloadButton.isEnabled = true
                self.spinner.alpha = 0
                self.spinner.stopAnimating()
            }
        }
    }
}
//MARK: - Implement save file Protocol methods
extension BookPageDetailsViewController : SaveFileProtocol{
    func fetchDownloadedFilePath(path: URL) {
        self.bookURL = path
        // add this book to the Realm DB 
        saveBookInfo()
    }
}
//MARK: - Realm Methods
extension BookPageDetailsViewController {
    // Check if the book is already exist
    func check(bookTitle:String) -> Bool{
        var status = false
        let realm = try! Realm()
        let results = realm.objects(Book.self).filter(NSPredicate(format: "bookTitle = %@", bookTitle))
        for result in results {
            if result.bookTitle == bookInfo?.volumeInfo?.title {
                status = true
                return status
            }
            else {
                return status
            }
        }
        return status
    }
    
    // Save Book information to the Realm DB
    func saveBookInfo(){
        let realm = try! Realm()
        let book = Book()
        if check(bookTitle: self.bookInfo?.volumeInfo?.title! ?? "") == true {
            print("book is already exist")
            self.bookPath = book.bookPath
        }
        else {
            book.isDownloaded = self.isDownloaded!
            book.bookPath = self.bookURL?.path ?? ""
            book.bookID = self.bookInfo?.volumeInfo?.id ?? "UnAvailable"
            book.bookTitle = self.bookInfo?.volumeInfo?.title! ?? ""
            book.authorName = self.bookInfo?.volumeInfo?.authors?[0] ?? "Unknown author"
            book.bookImage = self.bookInfo?.volumeInfo?.imageLinks?.thumbnail! ?? ""
            book.publishedDate = self.bookInfo?.volumeInfo?.publishedDate! ?? "UnKnown"
            
            try! realm.write({
                realm.add(book)
            })
        }
    }
    // Open the book from the the Realm DB
    func openBook(){
        let realm = try! Realm()
        let results = realm.objects(Book.self).toArray(type: Book.self)
        self.books = results
        for result in results {
            if result.bookTitle == self.bookInfo?.volumeInfo?.title {
                self.bookPath = result.bookPath
                self.bookReader.open(epub: bookPath!, parentViewController: self)
            }
            
        }
    }
}
//MARK: - Table View Delegate Methods
extension BookPageDetailsViewController : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.bookInfo
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookPosterCell", for: indexPath) as! BookPosterCell
            cell.configureCell(with: data!)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookInfoCell", for: indexPath) as! BookInfoCell
            cell.configureCell(with: data!)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookTitleCell", for: indexPath) as! BookTitleCell
            cell.configureCell(with: data!)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorNameCell", for: indexPath) as! AuthorNameCell
            cell.configureCell(with: data!)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookCategoriesCell", for: indexPath) as! BookCategoriesCell
            cell.configureCell(with: data!)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookDescriptionCell", for: indexPath) as! BookDescriptionCell
            cell.configureCell(with: data!)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            
        default:
            return UITableView.automaticDimension
        }
    }
}
