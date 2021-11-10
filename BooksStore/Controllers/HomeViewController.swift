//
// HomeViewController.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 22/10/2021.
//

import UIKit
import FolioReaderKit

class HomeViewController: UIViewController {
    
    //MARK:- Set Properties and Variables
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var bookCollectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var BooksInfo = [BookModel]()
    var dataModel = DataModel()
    var endpoint : Route?
    
    //MARK:- View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        dataModel.delegate = self
        bookCollectionView.delegate = self
        bookCollectionView.dataSource = self
        didSegmentChanged(self.segmentedControl)
    }
    //MARK:- Track segmented control index
    @IBAction func didSegmentChanged(_ sender: UISegmentedControl) {
        
        self.showIndicatorView()
        switch sender.selectedSegmentIndex {
        
        case 0:
            self.endpoint = .FictionBooksApi
            
        case 1:
            self.endpoint = .RomanceBooksApi
            
        case 2:
            self.endpoint = .Sci_Fi_BooksApi
            
        case 3:
            self.endpoint = .CrimeBooksApi
            
        default:
            self.endpoint = .FictionBooksApi
        }
        dataModel.fetchData(for: self.endpoint!)
    }
}
//MARK:- Methods
extension HomeViewController{
    func showIndicatorView(){
        // show & start indicator
        spinner.alpha = 1
        spinner.startAnimating()
        
        // and here you can hide other required elements
        bookCollectionView.alpha = 0
    }
    
    func hideIndicatorView(){
        // hide indicator
        spinner.stopAnimating()
        spinner.alpha = 0
        // and here you can show other required elements
        bookCollectionView.alpha = 1
    }
}
//MARK:- Collection View delegate Methods

extension HomeViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return BooksInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomBookCell", for: indexPath) as! CustomBookCell
        let data = BooksInfo[indexPath.row]
        cell.configureCell(with: data)
        return cell
        
    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
}


//MARK:- implement Protocol Books API Methods
extension HomeViewController : APIResponseProtocol {
    
    func booksRetrieved(data: [BookModel], for endpoint: Route) {
        self.BooksInfo = data
        self.endpoint = endpoint
        self.bookCollectionView.reloadData()
        // stop indicator
        self.hideIndicatorView()
    }
}
