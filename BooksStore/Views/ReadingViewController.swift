//
//  ReadingViewController.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 01/12/2021.
//

import UIKit
import CoreData
import FolioReaderKit
import RealmSwift

class ReadingViewController: UIViewController {
    
    //MARK: - Set Properties & Variables
    @IBOutlet weak var tabelView: UITableView!
    var BooksInfo:[Book] = []
    var readingTime = "00 : 00 : 00"
    var bookReader = BookReader()
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
        fetchBooks()
        fetchReadingTime()
    }
}
//MARK: - Realm Methods
extension ReadingViewController {
    func fetchReadingTime(){
        let realm = try! Realm()
        let results = realm.objects(TimeTracker.self).toArray(type: TimeTracker.self)
        if results.count == 0 {
            print("time is 0")
        }
        else {
            self.readingTime = results.first?.readingTime ?? self.readingTime
            print(self.readingTime)
        }
    }
    
    func fetchBooks(){
        let realm = try! Realm()
        let results = realm.objects(Book.self).toArray(type: Book.self)
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
            cell.time.text = self.readingTime
            return cell
        }
        
        else {
            let cell = tabelView.dequeueReusableCell(withIdentifier: "BookCardCell", for: indexPath) as! BookCardTableViewCell
            let data = BooksInfo[indexPath.row]
            cell.bookTitle.text = data.bookTitle
            cell.authorName.text = data.authorName
            cell.publishedDate.text = data.publishedDate
            cell.downloaadBookImage(imgeURL: data.bookImage)
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


