//
//  ShowCategoriesViewController.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 23/12/2021.
//

import UIKit

class ShowCategoriesViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = [BookModel]()
    var endpoint: TargetType?
    var dataModel = BooksAPIDataModel()
    var category: CategoriesModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.showIndicatorView()
        
        //Trigger Delegates
        dataModel.searchDelegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Register Cells
        collectionView.register(UINib(nibName: "ShowCategoriesCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCell")
        
        
        //Fetch Data from API
        dataModel.fetchSearchResults(searchKeyword: category?.categoryName ?? "Fiction")
    }
    //MARK: - Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailVC" {
            let showCategoriesVC = segue.destination as! BookPageDetailsViewController
            let indexPath = self.collectionView.indexPathsForSelectedItems?.first
            let selectedCategory = self.data[indexPath!.row]
            showCategoriesVC.bookInfo = selectedCategory
        }
    }
}
//MARK: - implement Protocol Books API Methods
extension ShowCategoriesViewController : SearchAPIProtocol{
    func didResultsFetched(data: [BookModel]) {
        self.data = data
        self.collectionView.reloadData()
        // stop indicator
        self.hideIndicatorView()
    }
}
//MARK: - Methods
extension ShowCategoriesViewController{
    func showIndicatorView(){
        // show & start indicator
        spinner.alpha = 1
        spinner.startAnimating()
        
        // and here you can hide other required elements
        collectionView.alpha = 0
    }
    
    func hideIndicatorView(){
        // hide indicator
        spinner.stopAnimating()
        spinner.alpha = 0
        // and here you can show other required elements
        collectionView.alpha = 1
    }
}
//MARK: - Collection View Delegate methods
extension ShowCategoriesViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCell", for: indexPath) as! ShowCategoriesCell
        let data = self.data[indexPath.row]
        cell.configureCell(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 2, bottom: 1, right: 2)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetailVC", sender: self)
    }
}
