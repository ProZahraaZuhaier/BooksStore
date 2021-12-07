//
//  TimeTracker+CoreDataProperties.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 05/12/2021.
//
//

import Foundation
import CoreData


extension TimeTracker {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeTracker> {
        return NSFetchRequest<TimeTracker>(entityName: "TimeTracker")
    }

    @NSManaged public var readingTime: String?

}

extension TimeTracker : Identifiable {

}
