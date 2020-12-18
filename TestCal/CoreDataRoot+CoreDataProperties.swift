//
//  CoreDataRoot+CoreDataProperties.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/12/17.
//
//

import Foundation
import CoreData


extension CoreDataRoot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataRoot> {
        return NSFetchRequest<CoreDataRoot>(entityName: "CoreDataRoot")
    }

    @NSManaged public var reservation: NSSet?

}

// MARK: Generated accessors for reservation
extension CoreDataRoot {

    @objc(addReservationObject:)
    @NSManaged public func addToReservation(_ value: Reservation)

    @objc(removeReservationObject:)
    @NSManaged public func removeFromReservation(_ value: Reservation)

    @objc(addReservation:)
    @NSManaged public func addToReservation(_ values: NSSet)

    @objc(removeReservation:)
    @NSManaged public func removeFromReservation(_ values: NSSet)

}

extension CoreDataRoot : Identifiable {

}
