//
//  BookPageDetailsViewController.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 16/11/2021.
//

import UIKit
import FolioReaderKit
import CoreData

class BookPageDetailsViewController: UIViewController {
    
    //MARK: - Set Properties & Variables
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var bookInfo: BookModel?
    var bookPath: String?
    var bookURL : URL?
    var isDownloaded:Bool?
    var downloader = DownloaderViewController()
    let folioReader = FolioReader()
    
    let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
    var books:[Book] = []
    //MARK: - View Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .dark
        
        //MARK: - Trigger Delegates
        tabelView.delegate = self
        tabelView.dataSource = self
        downloader.downloadStatusDelegate = self
        downloader.saveFileDelegate = self
      
        //MARK: - Register Cells
//        tabelView.register(UINib(nibName: "BookDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "bookDetailsCell")
        tabelView.register(UINib(nibName: "BookPosterCell", bundle: nil), forCellReuseIdentifier: "BookPosterCell")
        tabelView.register(UINib(nibName: "BookInfoCell", bundle: nil), forCellReuseIdentifier: "BookInfoCell")
        tabelView.register(UINib(nibName: "BookTitleCell", bundle: nil), forCellReuseIdentifier: "BookTitleCell")
        tabelView.register(UINib(nibName: "AuthorNameCell", bundle: nil), forCellReuseIdentifier: "AuthorNameCell")
        tabelView.register(UINib(nibName: "BookCategoriesCell", bundle: nil), forCellReuseIdentifier: "BookCategoriesCell")
        tabelView.register(UINib(nibName: "BookDescriptionCell", bundle: nil), forCellReuseIdentifier: "BookDescriptionCell")
        }
    
    //  check if the book is already downloaded or not to change download button label
    override func viewWillAppear(_ animated: Bool) {
        if check(context: context, bookTitle: bookInfo?.volumeInfo?.title! ?? "") == true {
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
            openBook(context: context)
        }
    }
}
//MARK: - Core Data Methods
extension BookPageDetailsViewController {
    
    func check(context:NSManagedObjectContext,bookTitle:String) -> Bool{
        var status = false
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "bookTitle = %@", bookTitle)
        let results = try! context.fetch(fetchRequest)
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
        // add this book to the core data
        saveBookInfo(context: self.context)
    }
}
//MARK: - Core data Methods
extension BookPageDetailsViewController {
    
    func openBook(context:NSManagedObjectContext){
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        let results = try! context.fetch(fetchRequest)
        self.books = results
        for result in results {
            self.bookPath = result.bookPath
            
        }
        print(self.bookPath)
        open(epub: self.bookPath!)
        
        
    }
    // Save Book information to the core data
    func saveBookInfo(context: NSManagedObjectContext){
        let book = Book(context: context)
        if check(context: context , bookTitle: self.bookInfo?.volumeInfo?.title! ?? "") == true {
            print("book is already exist")
            self.bookPath = book.bookPath!
        }
        else {
            book.isDownloaded = self.isDownloaded!
            book.bookPath = self.bookURL?.path
            book.bookID = self.bookInfo?.volumeInfo?.id
            book.bookTitle = self.bookInfo?.volumeInfo?.title
            book.authorName = self.bookInfo?.volumeInfo?.authors?[0] ?? "Unknown author"
            book.bookImage = self.bookInfo?.volumeInfo?.imageLinks?.thumbnail
            book.publishedDate = self.bookInfo?.volumeInfo?.publishedDate
            
            do {
                try context.save()
            }
            catch{
                print("Unable to Save Book, \(error)")
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
       
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookPosterCell", for: indexPath) as! BookPosterCell
            let data = self.bookInfo
            cell.configureCell(with: data!)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookInfoCell", for: indexPath) as! BookInfoCell
            let data = self.bookInfo
            cell.configureCell(with: data!)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookTitleCell", for: indexPath) as! BookTitleCell
            let data = self.bookInfo
            cell.configureCell(with: data!)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorNameCell", for: indexPath) as! AuthorNameCell
            let data = self.bookInfo
            cell.configureCell(with: data!)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookCategoriesCell", for: indexPath) as! BookCategoriesCell
            let data = self.bookInfo
            cell.configureCell(with: data!)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookDescriptionCell", for: indexPath) as! BookDescriptionCell
            let data = self.bookInfo
            cell.configureCell(with: data!)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
            return cell
        }
       
    }
}
//MARK: - FolioReader Configuration
extension  BookPageDetailsViewController {
    
    // FolioReader Open File method
    func open(epub: String) {
        
        let bookURL =  URL(string: epub)
        let fileName = bookURL!.deletingPathExtension().lastPathComponent
        let readerConfiguration = self.readerConfiguration(forEpub: fileName)
        print("file name is : \(fileName)")
        DispatchQueue.main.async {
            self.folioReader.presentReader(parentViewController: self , withEpubPath: epub, andConfig: readerConfiguration, shouldRemoveEpub: false)
        }
    }
    // FolioReader Configuration
    private func readerConfiguration(forEpub epub: String) -> FolioReaderConfig {
        let config = FolioReaderConfig(withIdentifier: epub)
        
        config.shouldHideNavigationOnTap = true
        config.scrollDirection = FolioReaderScrollDirection.vertical
        config.quoteCustomBackgrounds = []
        config.nightModeBackground = .black
        config.menuTextColor = .systemOrange
        config.tintColor = .systemOrange
        
        if let image = UIImage(named: "demo-bg") {
            let customImageQuote = QuoteImage(withImage: image, alpha: 0.6, backgroundColor: UIColor.black)
            config.quoteCustomBackgrounds.append(customImageQuote)
        }
        let textColor = UIColor(red:0.86, green:0.73, blue:0.70, alpha:1.0)
        let customColor = UIColor(red:0.30, green:0.26, blue:0.20, alpha:1.0)
        let customQuote = QuoteImage(withColor: customColor , alpha: 1.0, textColor: textColor)
        config.quoteCustomBackgrounds.append(customQuote)
        
        return config
    }
}

