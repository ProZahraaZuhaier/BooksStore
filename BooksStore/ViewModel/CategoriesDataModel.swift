//
//  CategoriesDataModel.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 23/12/2021.
//

import Foundation
//MARK: - Protocols
protocol CategoriesProtocol {
    func fetchCategories(data: [CategoriesModel])
}
//MARK: - Categories View Model
class CategoriesDataModel {
    var data: [CategoriesModel]?
    var delegate: CategoriesProtocol?
}
//MARK: - Handle Json Data 
extension CategoriesDataModel {
    func fetchCategories(){
        if let bundlePath = Bundle.main.url(forResource: "CategoriesData", withExtension: "json")
        {
            do {
                let data = try Data(contentsOf: bundlePath)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([CategoriesModel].self, from: data)
                self.delegate?.fetchCategories(data: dataFromJson)
                print(dataFromJson)
            }
            catch {
                print("something wrong with json file")
            }
    }

    }
}
