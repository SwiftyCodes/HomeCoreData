//
//  SingleFamily+CoreDataProperties.swift
//  Home
//
//  Created by Anurag Kashyap on 07/09/19.
//  Copyright © 2019 Anurag Kashyap. All rights reserved.
//
//

import Foundation
import CoreData


extension SingleFamily {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SingleFamily> {
        return NSFetchRequest<SingleFamily>(entityName: "SingleFamily")
    }

    @NSManaged public var lotSize: Int16

}
