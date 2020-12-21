//
//  Reservation+CoreDataProperties.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/12/21.
//
//

import Foundation
import CoreData


extension Reservation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reservation> {
        return NSFetchRequest<Reservation>(entityName: "Reservation")
    }

    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var hour: Int16
    @NSManaged public var index: Int16
    @NSManaged public var is_mine: Bool
    @NSManaged public var min: Int16

}

extension Reservation : Identifiable {

}
