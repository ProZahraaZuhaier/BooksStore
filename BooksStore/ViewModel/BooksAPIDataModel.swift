//
//  BooksAPIDataModel.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 12/12/2021.
//

import Foundation


protocol APIResponseProtocol {

    func booksRetrieved(data:[BookModel], for endpoint: TargetType)
}

protocol SearchAPIProtocol {
    func didResultsFetched(data:[BookModel])
}

class BooksAPIDataModel  {
    
    var delegate: APIResponseProtocol?
    var searchDelegate: SearchAPIProtocol?
    
    var data: [BookModel]?
    
    func fetchData(for endpoint : TargetType){
        
        NetworkService.shared.fetchBooks(route: endpoint, method: .get) { result in
         
            switch result {
            
            case .success(let data):
                self.data = data
                print(data)
                self.delegate?.booksRetrieved(data:  self.data! , for: endpoint)
                

            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func fetchSearchResults(searchKeyword:String){
        NetworkService.shared.fetchSearchResults(searchKeyword: searchKeyword , completion:
            
         { result in
            switch result {
            
            case .success(let data):
                self.data = data
                print(data)
                self.searchDelegate?.didResultsFetched(data: data)
                

            case .failure(let error):
                print(error)
            }
        })
    }
                                                 
}

