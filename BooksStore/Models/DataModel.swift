//
//  DataModel.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 21/10/2021.
//

import Foundation


protocol BooksAPI {

    func booksRetrieved(data: [BookModel] , for endpoint: Route)
}

class DataModel  {
    
    var delegate: BooksAPI?
    var data: [BookModel]?
    
    func fetchData(for endpoint : Route){
        
        NetworkService.shared.fetchBooks(route: endpoint, method: .get) { result in
         
            switch result {
            
            case .success(let data):
                self.data = data
                self.delegate?.booksRetrieved(data:  self.data! , for: endpoint)

            case .failure(let error):
                print(error)
            }
        }
    }
}
