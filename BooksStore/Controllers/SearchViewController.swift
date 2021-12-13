//
//  SearchViewController.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 28/11/2021.
//

import UIKit

class SearchViewController: UIViewController {
    //MARK: - Set Properties && Variables
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var BooksInfo = [BookModel]()
    var dataModel = BooksAPIDataModel()
    
    
    //MARK: - View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tabelView.delegate = self
        tabelView.dataSource = self
        dataModel.searchDelegate = self
        searchBar.delegate = self
        // Register Cells
        tabelView.register(UINib(nibName: "SearchResultsTableViewCell", bundle: nil), forCellReuseIdentifier: "searchResultsCell")
        
    }
    //MARK: - Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Detect the index path the user selected
        let indexPath = tabelView.indexPathForSelectedRow
        
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
}

//MARK: - Methods
extension SearchViewController{
    func showIndicatorView(){
        // show & start indicator
        spinner.alpha = 1
        spinner.startAnimating()
        
        // and here you can hide other required elements
        tabelView.alpha = 0
    }
    
    func hideIndicatorView(){
        // hide indicator
        spinner.stopAnimating()
        spinner.alpha = 0
        // and here you can show other required elements
        tabelView.alpha = 1
    }
}
//MARK: - SearchBar Delegate Methods
extension SearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchBar.placeholder = "search on something "
        }
        
        else {
            guard let text = searchBar.text else {
                return
            }
            let trimmedText = text.trimmingCharacters(in: .whitespaces)
            
            showIndicatorView()
            dataModel.fetchSearchResults(searchKeyword: trimmedText)
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tabelView.alpha = 0
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        hideIndicatorView()
        tabelView.alpha = 0
    }
}
//MARK: - implement Protocol Books API Methods
extension SearchViewController : SearchAPIProtocol {
    func didResultsFetched(data: [BookModel]) {
        self.BooksInfo = data
        hideIndicatorView()
        tabelView.reloadData()
    }
}
//MARK: - Tabel View Delegate Methods
extension SearchViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.BooksInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultsCell", for: indexPath) as! SearchResultsTableViewCell
        let data = BooksInfo[indexPath.row]
        cell.configureCell(with: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetailVC", sender: self)
        
    }
}
