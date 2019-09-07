//
//  Home+Extension.swift
//  Home
//
//  Created by Anurag Kashyap on 07/09/19.
//  Copyright © 2019 Anurag Kashyap. All rights reserved.
//

import Foundation
import CoreData

extension Home {
    
    func getHomeByStatus(isForSale : Bool, moc : NSManagedObjectContext)->[Home] {
        let reuqest : NSFetchRequest<Home> = Home.fetchRequest()
        reuqest.predicate = NSPredicate(format: "isForSale = %@", NSNumber(value: isForSale))
        
        do{
            let home = try moc.fetch(reuqest)
            return home
        }catch {
            fatalError("Could not fetch Data")
        }
    }
}
