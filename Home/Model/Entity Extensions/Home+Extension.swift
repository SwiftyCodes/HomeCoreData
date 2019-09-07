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
    
    func getHomeByStatus(isForSale : Bool, moc : NSManagedObjectContext, filterBy predicate : NSPredicate?, sortBy sort: [NSSortDescriptor]?)->[Home] {
        
        let reuqest : NSFetchRequest<Home> = Home.fetchRequest()
        var predicates = [NSPredicate]()
        
        let statusPredicate = NSPredicate(format: "isForSale = %@", NSNumber(value: isForSale))
        predicates.append(statusPredicate)
        
        if let additionalPredicate = predicate {
            predicates.append(additionalPredicate)
        }
        
        //Compound Predicate - This inform 'and operator' that we want isForSale & predicates Array together
        let compundPredicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        reuqest.predicate = compundPredicate
        reuqest.sortDescriptors = (sort?.isEmpty)! ? nil : sort
        
        do{
            let home = try moc.fetch(reuqest)
            return home
        }catch {
            fatalError("Could not fetch Data")
        }
    }
}
