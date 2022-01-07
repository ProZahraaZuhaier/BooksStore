//
// HomeViewController.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 22/10/2021.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    //MARK: - Set Properties and Variables
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var BooksTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet var mainView: UIView!
    
    var BooksInfo = [BookModel]()
    var dataModel = BooksAPIDataModel()
    var endpoint : TargetType?
    
    //MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        print(Realm.Configuration.defaultConfiguration.fileURL)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainView.alpha = 1
        dataModel.delegate = self
        BooksTableView.delegate = self
        BooksTableView.dataSource = self
        BooksTableView.register(UINib(nibName: "BookCardTableViewCell", bundle: nil), forCellReuseIdentifier: "BookCardCell")
        didSegmentChanged(self.segmentedControl)
    }
    //MARK: - Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Detect the index path the user selected
        let indexPath = BooksTableView.indexPathForSelectedRow
        guard indexPath != nil else {
            // the user hasn't selected anything
            return
        }
        // Get the book
        let bookInfo = BooksInfo[indexPath!.row]
        
        // Get a refrence to the book details view contrller
        let detailVC = segue.destination as! BookPageDetailsViewController
        
        // pass the book info to the book details view controller
        detailVC.bookInfo = bookInfo
    }
    //MARK: - Track segmented control index
    @IBAction func didSegmentChanged(_ sender: UISegmentedControl) {
        self.showIndicatorView()
        switch sender.selectedSegmentIndex {
            
//        case 0:
//            self.endpoint = .FictionBooksApi
//
//        case 1:
//            self.endpoint = .RomanceBooksApi
//
//        case 2:
//            self.endpoint = .Drama_BooksApi
//
//        case 3:
//            self.endpoint = .CrimeBooksApi
            
        default:
            self.endpoint = .general
        }
        dataModel.fetchData(for: self.endpoint!)
    }
}
//MARK: - Methods
extension HomeViewController{
    func showIndicatorView(){
        // show & start indicator
        spinner.alpha = 1
        spinner.startAnimating()
        
        // and here you can hide other required elements
        BooksTableView.alpha = 0
    }
    
    func hideIndicatorView(){
        // hide indicator
        spinner.stopAnimating()
        spinner.alpha = 0
        // and here you can show other required elements
        BooksTableView.alpha = 1
    }
}
//MARK: - Collection View delegate Methods

extension HomeViewController : UITableViewDelegate , UITableViewDataSource, UICollectionViewDelegateFlowLayout {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BooksInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCardCell", for: indexPath) as! BookCardTableViewCell
        let data = BooksInfo[indexPath.row]
        cell.configureCell(with: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetailVC", sender: self)
    }
}
//MARK: - implement Protocol Books API Methods
extension HomeViewController : APIResponseProtocol {
    func booksRetrieved(data: [BookModel], for endpoint: TargetType) {
        self.BooksInfo = data
        self.endpoint = endpoint
        self.BooksTableView.reloadData()
        // stop indicator
        self.hideIndicatorView()
    }
}
