//
//  CoreDataManager.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/12/16.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private var container : NSPersistentCloudKitContainer
    
    init() {
        self.container = NSPersistentCloudKitContainer(name: "CoreDataModel")
        self.container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error as NSError? {
                fatalError("error \(error), \(error.userInfo)")
            }
        })
        
        // delete for test
        //deleteAll()
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteAll() {
        while(!getReservations(predicate: nil).isEmpty) {
            delete(src: getReservations(predicate: nil)[0])
        }
    }
    
    func delete(src: Reservation) {
        let context = container.viewContext
        context.delete(src)
    }
    
    func addReservation(date: Date, category: String, index: Int, hour: Int, min: Int, is_mine: Bool) -> Reservation {
        let context = container.viewContext
        let reservation = NSEntityDescription.insertNewObject(forEntityName: "Reservation", into: context) as! Reservation
        
        reservation.date = date
        reservation.category = category
        reservation.index = Int16(index)
        reservation.hour = Int16(hour)
        reservation.min = Int16(min)
        reservation.is_mine = is_mine
        
        return reservation
    }
    
    func getReservations(predicate: NSPredicate?) -> [Reservation] {
        let context = container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reservation")
        request.predicate = predicate
        
        do {
            return try context.fetch(request) as! [Reservation]
        }
        catch {
            fatalError()
        }
    }
    
    func getReservation(date: Date, category: String, index: Int) -> Reservation? {
        let predicate = NSPredicate(format: "date == %@ AND category == %@ AND index == %@", argumentArray: [date as NSDate, category, index])
        let result = getReservations(predicate: predicate)
        
        // check duplicated save data
        if result.count > 1 {
            fatalError()
        }
        
        return result.isEmpty ? nil : result[0]
    }
}
