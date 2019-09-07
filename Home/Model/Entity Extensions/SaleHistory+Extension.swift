//
//  SaleHistory+Extension.swift
//  Home
//
//  Created by Anurag Kashyap on 07/09/19.
//  Copyright © 2019 Anurag Kashyap. All rights reserved.
//

import Foundation
import CoreData

extension SaleHistory {
    
    func getSoldHistoryData(home : Home, moc : NSManagedObjectContext)->[SaleHistory] {
        let reuqest : NSFetchRequest<SaleHistory> = SaleHistory.fetchRequest()
        reuqest.predicate = NSPredicate(format: "home = %@", home)
        
        do{
            let saleHistory = try moc.fetch(reuqest)
            return saleHistory
        }catch {
            fatalError("Could not fetch Data")
        }
    }
}

