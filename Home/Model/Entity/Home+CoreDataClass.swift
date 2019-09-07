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
    
    
    //AGREGATED FUNCTIONS
    
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
        //Compound PREDICATE
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
    
    
    //MAX & MIN Price - Value
    func soldPrice(priceType: String, moc : NSManagedObjectContext) -> Double {
        
        request.predicate = isForSalePredicate
        request.resultType = .dictionaryResultType
        
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = "priceType" // Key for accessing the total sales as we have used a dictinory
        //Build Expression
        sumExpressionDescription.expression = NSExpression(forFunction: "\(priceType):", arguments: [NSExpression(forKeyPath: "price")]) // Price type is min or max
        //What we want the value as - here its DOUBLE
        sumExpressionDescription.expressionResultType = .doubleAttributeType
        //QUERY
        request.propertiesToFetch = [sumExpressionDescription]
        
        if let results = try? moc.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as? [NSDictionary], let homePrice = results?.first?["priceType"] as? Double {
            return homePrice
        }
        
        return 0
    }
    
    //Avg Price
    func averagePrice(for homeType: HomeType, moc : NSManagedObjectContext) -> Double {
        
        let typPredicate = NSPredicate(format: "homeType = %@", homeType.rawValue)
        let predicate = NSCompoundPredicate(type: .and, subpredicates: [isForSalePredicate, typPredicate])
        request.predicate = predicate
        request.resultType = .dictionaryResultType
        
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = homeType.rawValue // Key for accessing the total sales as we have used a dictinory
        //Build Expression
        sumExpressionDescription.expression = NSExpression(forFunction: "average:", arguments: [NSExpression(forKeyPath: "price")]) // Price type is min or max
        //What we want the value as - here its DOUBLE
        sumExpressionDescription.expressionResultType = .doubleAttributeType
        //QUERY
        request.propertiesToFetch = [sumExpressionDescription]
        
        if let results = try? moc.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as? [NSDictionary], let homePrice = results?.first?[homeType.rawValue] as? Double {
            return homePrice
        }
        
        return 0
    }
}
