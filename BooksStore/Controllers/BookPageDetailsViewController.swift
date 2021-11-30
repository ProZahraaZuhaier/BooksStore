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
    var cellModel = BookDetailsTableViewCell()
    let folioReader = FolioReader()
    let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
    var books:[Book]?
    
    
    //MARK: - View Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        overrideUserInterfaceStyle = .dark
     
        //MARK: - Trigger Delegates
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.register(UINib(nibName: "BookDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "bookDetailsCell")
        downloader.downloadStatusDelegate = self
        downloader.saveFileDelegate = self
       
    }
    //MARK: - Methods
    @IBAction func downloadButtonTapped(_ sender: Any) {
  
        if downloadButton.titleLabel?.text == "Download"{
            let bookURL = self.bookInfo?.volumeInfo?.previewLink
            DispatchQueue.main.async {
                self.downloadButton.isEnabled = false
                self.spinner.alpha = 1
                self.spinner.startAnimating()
            }
            // test url
            self.downloader.downloadBook(from: "https://filesamples.com/samples/ebook/epub/Sway.epub")

        }
        
        else {

            self.open(epub: self.bookURL?.path ?? "")
            
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
        // add this book to the core data
        saveBookInfo(context: self.context)
    }
}
//MARK: - Core data Methods
extension BookPageDetailsViewController {
    func saveBookInfo(context: NSManagedObjectContext){
 
    let book = Book(context: context)
    
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
    
//    func fetchData(context: NSManagedObjectContext){
//        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
//        let results = try! context.fetch(fetchRequest)
//        self.books = results
//        print(self.books)
//
//        for result in results {
//            if result.bookID == self.bookInfo?.volumeInfo?.id{
//                print(result.bookID)
//                print(self.bookInfo?.volumeInfo?.id)
//            }
////            print(result.bookTitle)
////            print(result.bookPath)
////            print(result.isDownloaded)
//    }
//}
}
//MARK: - Table View Delegate Methods
extension BookPageDetailsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookDetailsCell", for: indexPath) as! BookDetailsTableViewCell
        let data = self.bookInfo
        cell.configureCell(with: data!)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1500;
    }
}
//MARK: - FolioReader Open File method
extension BookPageDetailsViewController {
    
    func open(epub: String) {
        
        let bookURL =  URL(string: epub)
        let fileName = bookURL!.deletingPathExtension().lastPathComponent
        let readerConfiguration = self.readerConfiguration(forEpub: fileName)
        print("file name is : \(fileName)")
        DispatchQueue.main.async {
            self.folioReader.presentReader(parentViewController: self , withEpubPath: epub, andConfig: readerConfiguration, shouldRemoveEpub: false)
    }
}
}
//MARK: - FolioReader Configuration
extension  BookPageDetailsViewController {
    
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

