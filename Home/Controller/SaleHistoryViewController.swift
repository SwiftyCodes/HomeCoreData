//
//  SaleHistoryViewController.swift
//  Home Report
//
//  Created by Andi Setiyadi on 9/1/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import UIKit
import CoreData

class SaleHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Property
    private lazy var soldHistory = [SaleHistory]()
    var home: Home?
    weak var managedObjectContext: NSManagedObjectContext! {
        didSet{
            saleHistory = SaleHistory(context: managedObjectContext)
        }
    }
    private var saleHistory : SaleHistory?
    // MARK - Outlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        if let homeImage = home?.image as Data? {
            imageView.image = UIImage(data: homeImage)
            imageView.layer.borderWidth = 1
            imageView.layer.cornerRadius = 4
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Tableview datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soldHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! SaleHistoryTableViewCell
        
        let saleHistory = soldHistory[indexPath.row]
        cell.configureCell(saleHistory: saleHistory)
        
        return cell
    }
    
    
    private func loadData(){
        if let homeValue = home {
            if let saleHistory = saleHistory?.getSoldHistoryData(home: homeValue, moc: managedObjectContext) {
                self.soldHistory = saleHistory
                tableView.reloadData()
            }
        }
    }
}
