//
//  CoreDataManager.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/12/16.
//

import Foundation
import CoreData

extension Notification.Name {
    static let save = Notification.Name("save")
}

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
        // deleteAll()
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                NotificationCenter.default.post(name: .save, object: nil)
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
        save()
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
        let predicate = generatePredicate(date: date, category: category, index: index)
        let result = getReservations(predicate: predicate)
        
        // check duplicated save data
        if result.count > 1 {
            fatalError()
        }
        
        return result.isEmpty ? nil : result[0]
    }
    
    func addPredicateArg(format: inout String, args: inout Array<Any>, name: String, val: Any?, operator_str: String = "==") {
        if val == nil {
            return
        }
        
        args.append(type(of: val!) == Date.self ? val! as! NSDate : val!)
        if format.isEmpty {
            format.append(name + operator_str + "%@")
        } else {
            format.append(" AND " + name + operator_str + "%@")
        }
    }
    
    func generatePredicate(date: Date? = nil, start_date: Date? = nil, end_date: Date? = nil, category: String? = nil, index: Int? = nil, is_mine: Bool? = nil) -> NSPredicate {
        
        // check invalid date setting
        if (date != nil && start_date != nil || date != nil && end_date != nil) {
            fatalError()
        }
        
        var format = ""
        var args: Array<Any> = []
        
        addPredicateArg(format: &format, args: &args, name: "date", val: date)
        addPredicateArg(format: &format, args: &args, name: "date", val: start_date, operator_str: ">=")
        addPredicateArg(format: &format, args: &args, name: "date", val: end_date, operator_str: "<")
        addPredicateArg(format: &format, args: &args, name: "category", val: category)
        addPredicateArg(format: &format, args: &args, name: "index", val: index)
        addPredicateArg(format: &format, args: &args, name: "is_mine", val: is_mine)
        
        return NSPredicate(format: format, argumentArray: args)
    }
}
