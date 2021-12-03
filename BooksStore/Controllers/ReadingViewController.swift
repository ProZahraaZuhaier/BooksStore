//
//  ReadingViewController.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 01/12/2021.
//

import UIKit
import CoreData
import FolioReaderKit

class ReadingViewController: UIViewController {

    //MARK: - Set Properties & Variables
    @IBOutlet weak var tabelView: UITableView!
    var BooksInfo:[Book] = []
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let folioReader = FolioReader()
    //MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabelView.delegate = self
        tabelView.dataSource = self
    
        tabelView.register(UINib(nibName: "TodayReadingTableViewCell", bundle: nil), forCellReuseIdentifier: "readingTimeCell")
        tabelView.register(UINib(nibName: "BookCardTableViewCell", bundle: nil), forCellReuseIdentifier: "BookCardCell")

    }
    override func viewWillAppear(_ animated: Bool) {
        // Fetch data from core data
        fetchBooks(context: context)
    }
}
//MARK: - Core Data Methods
extension ReadingViewController {
func fetchBooks(context:NSManagedObjectContext){
    let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
    let results = try! context.fetch(fetchRequest)
    self.BooksInfo = results
    
    tabelView.reloadData()
}
    

}
//MARK: - Table View Delegate Methods
extension ReadingViewController : UITableViewDelegate , UITableViewDataSource {
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return BooksInfo.count
       default:
            return BooksInfo.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tabelView.dequeueReusableCell(withIdentifier: "readingTimeCell", for: indexPath) as! TodayReadingTableViewCell
            cell.time.text = "00:00:00"
            return cell
        }
        
        else {
            let cell = tabelView.dequeueReusableCell(withIdentifier: "BookCardCell", for: indexPath) as! BookCardTableViewCell
            let data = BooksInfo[indexPath.row]
            cell.bookTitle.text = data.bookTitle
            cell.authorName.text = data.authorName
            cell.publishedDate.text = data.publishedDate
            cell.downloaadBookImage(imgeURL: data.bookImage!)
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Today's Reading"
        case 1:
            return "Continue Reading"
        default:
            return ""
        }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookPath = self.BooksInfo[indexPath.row].bookPath!
        print("the bookPath from core data is : \(bookPath)")
        self.open(epub: bookPath)
        
    }
}
//MARK: - FolioReader Configuration
extension  ReadingViewController {
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
    
    //MARK: - FolioReader Open File method
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

