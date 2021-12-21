//
//  ReadingViewController.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 01/12/2021.
//

import UIKit
import RealmSwift

class ReadingViewController: UIViewController {
    
    //MARK: - Set Properties & Variables
    @IBOutlet weak var tabelView: UITableView!
    var BooksInfo:[Book] = []
    var readingTime = "00 : 00 : 00"
    var bookReader = BookReader()
    var realmViewModel = RealmViewModel()
    //MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tabelView.delegate = self
        tabelView.dataSource = self
        realmViewModel.booksDelegate = self
        
        tabelView.register(UINib(nibName: "TodayReadingTableViewCell", bundle: nil), forCellReuseIdentifier: "readingTimeCell")
        tabelView.register(UINib(nibName: "BookCardTableViewCell", bundle: nil), forCellReuseIdentifier: "BookCardCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // Fetch data from Realm DB
        self.realmViewModel.fetchBooks()
        self.realmViewModel.fetchReadingTime()
        
    }
}
//MARK: - Fetch Data from RealmDB
extension ReadingViewController : RealmDBProtocol{
    func fetchReadingTime(readingTime: String) {
        self.readingTime = readingTime
    }
    
    func fetchBooks(books: [Book]) {
        self.BooksInfo = books
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
            cell.time.text = self.readingTime
            return cell
        }
        
        else {
            let cell = tabelView.dequeueReusableCell(withIdentifier: "BookCardCell", for: indexPath) as! BookCardTableViewCell
            let data = BooksInfo[indexPath.row]
            cell.setupCell(with: data)
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
        let bookPath = self.BooksInfo[indexPath.row].bookPath
        print("the bookPath from core data is : \(bookPath)")
        self.bookReader.open(epub: bookPath, parentViewController: self)
    }
}


