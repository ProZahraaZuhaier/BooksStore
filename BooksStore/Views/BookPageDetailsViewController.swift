//
//  BookPageDetailsViewController.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 16/11/2021.
//

import UIKit
import RealmSwift

class BookPageDetailsViewController: UIViewController {
    
    //MARK: - Set Properties & Variables
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var bookInfo: BookModel?
    var bookURL : URL?
    var isDownloaded:Bool = false
    var downloader = DownloadManager()
    var realmViewModel = RealmViewModel()
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
        if self.realmViewModel.check(bookData: self.bookInfo!) == true {
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
            //let bookURL = self.bookInfo?.volumeInfo?.previewLink
            self.checkDownloadButtonState(state: false)
            
            // test url
            self.downloader.downloadBook(from: "https://filesamples.com/samples/ebook/epub/Sway.epub")
        }
        else {
            // open the book from the Realm DB
            self.realmViewModel.openBook(bookData: self.bookInfo!, parentViewController: self)
        }
    }
    
    // - Handle download button state
    func checkDownloadButtonState(state: Bool) {
        if state == true {
            DispatchQueue.main.async {
                self.downloadButton.setTitle("Open", for: .normal)
                self.downloadButton.isEnabled = true
                self.spinner.alpha = 0
                self.spinner.stopAnimating()
            }
        }
        else {
            DispatchQueue.main.async {
                self.downloadButton.isEnabled = false
                self.spinner.alpha = 1
                self.spinner.startAnimating()
            }
        }
    }
}
//MARK: - Implement download Protocol methods
extension BookPageDetailsViewController : DownloadFileProtocol {
    func didFileDownloaded(status: Bool) {
        self.isDownloaded = status
        self.checkDownloadButtonState(state: self.isDownloaded)
    }
}
//MARK: - Implement save file Protocol methods
extension BookPageDetailsViewController : SaveFileProtocol{
    func fetchDownloadedFilePath(path: URL) {
        self.bookURL = path
        // add this book to the Realm DB
        realmViewModel.saveBookInfo(downloadState: self.isDownloaded, bookData: self.bookInfo!, bookURL: path)
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
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
}
