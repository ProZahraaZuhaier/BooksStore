//
//  TimeManager.swift
//  BooksStore
//
//  Created by Zahraa Zuhaier L on 05/12/2021.


import Foundation
import UIKit
import CoreData

class TimeManager {
    //MARK: - Set Variables
    var timer: Timer = Timer()
        var count:Int = 0
        var timerCounting:Bool = false
    //MARK: - Call this function to start timer
    func timerGetFired (timerCounting: Bool){
        self.timerCounting = timerCounting
            if(timerCounting == false)
            {
                self.timer.invalidate()
                print("timer stop")
            }
            else
            {
                print("timer get started")
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            }
        }
    //MARK: - set an action when timer get fired
    @objc func timerCounter() -> Void
    {
        count = count + 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        updateTime(context: context, timeString: timeString)
    }
 //MARK: - Configure Time Format
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int)
        {
            return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60))
        }
        
   func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String
        {
            var timeString = ""
            timeString += String(format: "%02d", hours)
            timeString += " : "
            timeString += String(format: "%02d", minutes)
            timeString += " : "
            timeString += String(format: "%02d", seconds)
            return timeString
        }
}
//MARK: - Update Core Data
extension TimeManager {
    func updateTime(context: NSManagedObjectContext , timeString : String){
        let fetchRequest: NSFetchRequest<TimeTracker> = TimeTracker.fetchRequest()
        let results = try! context.fetch(fetchRequest)
        print("results count is \(results.count)")
        if results.count == 0 {
             let time = TimeTracker(context: context)
             time.readingTime = timeString
            do {
                      try context.save()
                  }
                  catch{
                      print("Unable to update the timer, \(error)")
                  }
        }
        else {
            
            results[0].setValue(timeString, forKey: "readingTime")
            print(results[0].readingTime)
           
            do {
                      try context.save()
                  }
                  catch{
                      print("Unable to update the timer, \(error)")
                  }
        }
      
    }

}
