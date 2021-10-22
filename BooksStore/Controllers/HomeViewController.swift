//
//  TestViewController.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 22/10/2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var bookCollectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var BooksInfo = [BookModel]()
    var dataModel = DataModel()
    var endpoint : Route?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupView()
        dataModel.delegate = self
        bookCollectionView.delegate = self
        bookCollectionView.dataSource = self
        didSegmentChanged(self.segmentedControl)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        spinner.alpha = 1
        spinner.startAnimating()
    }
    
    //MARK:- setup UI function
    func setupView(){
        shadowView.layer.cornerRadius = 10
        cardView.layer.cornerRadius = 8
        shadowView.layer.shadowColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.5)
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 8
    }
    
    //MARK:- Track segmented control index
    @IBAction func didSegmentChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        
        case 0:
            spinner.alpha = 1
            spinner.startAnimating()
            bookCollectionView.alpha = 0
            self.endpoint = .FictionBooksApi
            dataModel.fetchData(for: self.endpoint!)
            
           
            
        case 1:
            spinner.alpha = 1
            spinner.startAnimating()
            bookCollectionView.alpha = 0
            self.endpoint = .RomanceBooksApi
            dataModel.fetchData(for: self.endpoint!)
            
        case 2:
            spinner.alpha = 1
            spinner.startAnimating()
            bookCollectionView.alpha = 0
            self.endpoint = .Sci_Fi_BooksApi
            dataModel.fetchData(for: self.endpoint!)
            
        case 3:
            spinner.alpha = 1
            spinner.startAnimating()
            bookCollectionView.alpha = 0
            self.endpoint = .CrimeBooksApi
            dataModel.fetchData(for: self.endpoint!)
            
        default:
            spinner.alpha = 1
            spinner.startAnimating()
            bookCollectionView.alpha = 0
            self.endpoint = .FictionBooksApi
            dataModel.fetchData(for: self.endpoint!)
            
        }
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
}
//MARK:- implement Protocol Books API Methods
extension HomeViewController : BooksAPI {
    
    func booksRetrieved(data: [BookModel], for endpoint: Route) {
        self.BooksInfo = data
        self.endpoint = endpoint
        self.bookCollectionView.reloadData()
        spinner.stopAnimating()
        spinner.alpha = 0
        bookCollectionView.alpha = 1
    }
    
    
}
