//
//  Reservation+CoreDataProperties.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/12/17.
//
//

import Foundation
import CoreData


extension Reservation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reservation> {
        return NSFetchRequest<Reservation>(entityName: "Reservation")
    }

    @NSManaged public var date: Date?
    @NSManaged public var staff_id: Int16
    @NSManaged public var hour: Int16
    @NSManaged public var min: Int16
    @NSManaged public var index: Int16
    @NSManaged public var category: String?
    @NSManaged public var controller: CoreDataRoot?

}

extension Reservation : Identifiable {

}
