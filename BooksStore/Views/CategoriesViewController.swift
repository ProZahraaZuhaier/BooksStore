//
//  CategoriesViewController.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 22/12/2021.
//

import UIKit

class CategoriesViewController: UIViewController {
    //MARK: - Set Properties && Variables
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data: [CategoriesModel]?
    var categoriesData = CategoriesDataModel()
    //MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Trigger delegates
        categoriesData.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        //Register Cells
        collectionView.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        // fetch categories
        categoriesData.fetchCategories()
    }
    //MARK: - Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToShowCategoriesVC" {
            let showCategoriesVC = segue.destination as! ShowCategoriesViewController
            let indexPath = self.collectionView.indexPathsForSelectedItems?.first
            let selectedCategory = self.data?[indexPath!.row]
            showCategoriesVC.category = selectedCategory
        }
    }
}
//MARK: - Fetch Categories from Categories Protocol
extension CategoriesViewController : CategoriesProtocol {
    func fetchCategories(data: [CategoriesModel]) {
        self.data = data
        collectionView.reloadData()
    }
}
//MARK: - Collection View Delegate Methods
extension CategoriesViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data!.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoriesCollectionViewCell
        let data = self.data?[indexPath.row]
        cell.configureCell(data: data!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToShowCategoriesVC", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 2, bottom: 1, right: 2)
    }
}
