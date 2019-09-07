//
//  AppDelegate.swift
//  Home Report
//
//  Created by Andi Setiyadi on 8/30/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coreData = CoreDataStack()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //deleteRecords()
        checkDataStore()
        
        let managedObjectContext = coreData.persistentContainer.viewContext
        let tabBarController = self.window?.rootViewController as! UITabBarController
        
        // First Tab - Home List
        let homeListNavigationController = tabBarController.viewControllers?[0] as! UINavigationController
        let homeListViewController = homeListNavigationController.topViewController as! HomeListViewController
        homeListViewController.managedObjectContext = managedObjectContext
        
        // Second Tab - Summary View
        let summaryNavigationController = tabBarController.viewControllers?[1] as! UINavigationController
        let summaryViewController = summaryNavigationController.topViewController as! SummaryTableViewController
        summaryViewController.managedObjectContext = managedObjectContext
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreData.saveContext()
    }

    func checkDataStore() {
        let request: NSFetchRequest<Home> = Home.fetchRequest()
        
        let moc = coreData.persistentContainer.viewContext
        do {
            let homeCount = try moc.count(for: request)
            
            if homeCount == 0 {
                uploadSampleData()
            }
        }
        catch {
            fatalError("Error in counting home record")
        }
    }
    
    func uploadSampleData() {
        let moc = coreData.persistentContainer.viewContext
        
        if  let url = Bundle.main.url(forResource: "homes", withExtension: "json"),
            let data = try? Data(contentsOf: url) {
            
            do {
                if  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary,
                    let jsonArray = jsonResult.value(forKey: "home") as? NSArray {
                    
                    for json in jsonArray {
                        if let homeData = json as? [String: AnyObject] {
                            guard
                                let bath = homeData["bath"],
                                let bed = homeData["bed"],
                                let city = homeData["city"],
                                let price = homeData["price"],
                                let sqft = homeData["sqft"],
                                let homeCategory = homeData["category"] as? NSDictionary,
                                let homeStatus = homeData["status"] as? NSDictionary
                                else {
                                    return
                            }
                            
                            var image = UIImage()
                            if let imageName = homeData["image"] as? String, let currentImage = UIImage(named: imageName) {
                                image = currentImage
                            }
                            
                            let homeType = homeCategory["homeType"] as? String
                            let isForSale = homeStatus["isForSale"] as? Bool
                            
                            let home = homeType?.caseInsensitiveCompare("condo") == .orderedSame ? Condo(context: moc): SingleFamily(context: moc)
                            
                            home.price = (price as? Double) ?? 0.00
                            home.bed = bed.int16Value
                            home.bath = bath.int16Value
                            home.sqft = sqft.int16Value
                            home.image = image.jpegData(compressionQuality: 1.0) as NSData?
                            home.homeType = homeType
                            home.city = city as? String
                            home.isForSale = isForSale ?? false
                            
                            if let unitsPerBuilding = homeData["unitsPerBuilding"], home.isKind(of: Condo.self) {
                                (home as! Condo).unitsPerBuilding = unitsPerBuilding.int16Value
                            }
                            
                            if let lotSize = homeData["lotSize"], home.isKind(of: SingleFamily.self) {
                                (home as! SingleFamily).lotSize = lotSize.int16Value
                            }
                            
                            if let saleHistories = homeData["saleHistory"] as? NSArray {
                                let saleHistoryData = home.saleHistory?.mutableCopy() as! NSMutableSet
            
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                
                                for saleDetail in saleHistories {
                                    if let saleData = saleDetail as? [String: AnyObject] {
                                        
                                        //Saving data to sale Hosoty
                                        let saleHistory = SaleHistory(context: moc)
                                        
                                        if let soldPrice = saleData["soldPrice"] as? Double {
                                            saleHistory.soldPrice = soldPrice
                                        }
                                        
                                        if  let soldDateStr = saleData["soldDate"] as? String,
                                            let soldDate = dateFormatter.date(from: soldDateStr) as NSDate? {
                                            saleHistory.soldDate = soldDate
                                        }
                                        
                                        saleHistoryData.add(saleHistory)
                                    }
                                }
                                
                                home.addToSaleHistory(saleHistoryData.copy() as! NSSet)
                            }
                        }
                    }
                }
                
                coreData.saveContext()
            }
            catch {
                fatalError("Cannot upload sample data")
            }
        }
    }

    
}

