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
        
        // confirm the existance of CoreDataRoot
        if (getCoreDataRoot().count == 0)
        {
            let context = container.viewContext
            NSEntityDescription.insertNewObject(forEntityName: "CoreDataRoot", into: context)
            save()
        }
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
    
    func delete(root: CoreDataRoot) {
        let context = container.viewContext
        context.delete(root)
    }
    
    func getCoreDataRoot() -> [CoreDataRoot] {
        let context = container.viewContext
        let request = NSFetchRequest<CoreDataRoot>(entityName: "CoreDataRoot")
        do {
            return try context.fetch(request)
        }
        catch {
            fatalError()
        }
    }
    
    func getReservations() -> [Reservation] {
        let context = container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reservation")
        do {
            return try context.fetch(request) as! [Reservation]
        }
        catch {
            fatalError()
        }
    }
}
