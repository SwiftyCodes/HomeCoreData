//
//  FilterTableViewController.swift
//  Home Report
//
//  Created by Andi Setiyadi on 9/1/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import UIKit

protocol FilterTableViewControllerDelegate: class {
    func updateHomeList(filterby: NSPredicate?, sortby: NSSortDescriptor?)
}

class FilterTableViewController: UITableViewController {

    // SORT BY
    @IBOutlet weak var sortByLocationCell: UITableViewCell!
    @IBOutlet weak var sortByPriceLowHighCell: UITableViewCell!
    @IBOutlet weak var sortByPriceHighLowCell: UITableViewCell!
    
    // FILTER by home type
    @IBOutlet weak var filterByCondoCell: UITableViewCell!
    @IBOutlet weak var filterBySingleFamilyCell: UITableViewCell!
   
    private var sortDescriptor : NSSortDescriptor?
    private var predicate : NSPredicate?
    
    var delegate : FilterTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 2
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedCell = tableView.cellForRow(at: indexPath) {
            
            switch selectedCell {
                
                //SORT
            case sortByLocationCell:
                setSortDescriptor(sortBy: "city", isAscendingOrder: true)
                
            case sortByPriceLowHighCell:
                setSortDescriptor(sortBy: "price", isAscendingOrder: true)
            case sortByPriceHighLowCell:
                setSortDescriptor(sortBy: "price", isAscendingOrder: false)
                
                //FILTER- PREDICATE
            case filterByCondoCell, filterBySingleFamilyCell:
                setFilterSearchPredicate(filterBy: (selectedCell.textLabel?.text)!)
                
            default:
                break
            }
            selectedCell.accessoryType = .checkmark
            delegate?.updateHomeList(filterby: predicate, sortby: sortDescriptor)
        }
        
    }
    
    private func setSortDescriptor(sortBy : String, isAscendingOrder : Bool) {
        sortDescriptor = NSSortDescriptor(key: sortBy, ascending: isAscendingOrder)
    }
    
    private func setFilterSearchPredicate(filterBy : String) {
        predicate = NSPredicate(format: "homeType = %@", filterBy)
    }
}
