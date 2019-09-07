//
//  Home+CoreDataClass.swift
//  Home
//
//  Created by Anurag Kashyap on 07/09/19.
//  Copyright © 2019 Anurag Kashyap. All rights reserved.
//
//

import Foundation
import CoreData


public class Home: NSManagedObject {

    private let isForSalePredicate = NSPredicate(format: "isForSale = false")
    private let request : NSFetchRequest<Home> = Home.fetchRequest()
    
    //Total Home Sales
    func totalHomeSale(moc : NSManagedObjectContext)->Double {
        request.predicate = isForSalePredicate
        request.resultType = .dictionaryResultType //The request returns dictionaries.
        
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = "totalSales" // Key for accessing the total sales as we have used a dictinory
        sumExpressionDescription.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "price")])
        sumExpressionDescription.expressionResultType = .doubleAttributeType
        request.propertiesToFetch = [sumExpressionDescription]
        
        if let results = try? moc.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as? [NSDictionary], let totalSales = results?.first?["totalSales"] as? Double {
            return totalSales
        }
        
        return 0
    }
    
    
    //Condo Count
    func totalSoldCondo(moc : NSManagedObjectContext)-> Int {
        let typPredicate = NSPredicate(format: "homeType = '\(HomeType.Condo.rawValue)'")
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [isForSalePredicate, typPredicate])
        request.resultType = .countResultType //The request returns the count of the objects that match the request.
        request.predicate = predicate
        
        if let results = try? moc.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as? [Int], let count = results?.first {
            return count
        }
        
        return 0
    }
    
    //Single Family Count
    func totalSoldSingleFamily(moc : NSManagedObjectContext) -> Int {
        let typPredicate = NSPredicate(format: "homeType = '\(HomeType.SingleFamily.rawValue)'")
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [isForSalePredicate, typPredicate])
        request.predicate = predicate
        
        if let count = try? moc.count(for: request), count != NSNotFound {
            return count
        }
        
        return 0
    }
}
