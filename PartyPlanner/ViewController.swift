//
//  ViewController.swift
//  PartyPlanner
//
//  Created by Andrew Chapman on 10/25/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var partyItems = ["Potato Chips",
                      "Tortilla Chips",
                      "Salsa",
                      "Chili",
                      "Punch",
                      "Sudsy Beverages",
                      "Brownies",
                      "Cupcakes",
                      "Fruit salad",
                      "Ribs",
                      "Corn bread",
                      "Macaroni Salad",
                      "Sandwich Rolls",
                      "Roast Beef",
                      "Ham",
                      "Cheese",
                      "Mayo",
                      "Mustard",
                      "Hummus",
                      "Baby carrots",
                      "Celery",
                      "Veggie Dip",
                      "Napkins",
                      "Plates & Bowls",
                      "Forks and Knives",
                      "Cups"]

    var partyPlannerArray: [PartyPlannerListItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        for partyItem in partyItems {
            partyPlannerArray.append(PartyPlannerListItem(item: partyItem, personResponsible: ""))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! DetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.partyPlannerListItem = partyPlannerArray[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromDetailViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! DetailViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            partyPlannerArray[selectedIndexPath.row] = source.partyPlannerListItem
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: partyPlannerArray.count, section: 0)
            partyPlannerArray.append(source.partyPlannerListItem)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
    }

    @IBAction func editButtonPressed(_ sender: Any) {
        if tableView.isEditing { // If button clicked while editing, I'm done
            tableView.setEditing(false, animated: true) // turn off tableView editing
            editBarButton.title = "Edit" // set button label so it can re-start edit
            addBarButton.isEnabled = true // enable the "+" button
        } else { // I wasn't editing, so start editing
            tableView.setEditing(true, animated: true) // turn on tableView editing
            editBarButton.title = "Done" // set button label so it can stop edit
            addBarButton.isEnabled = false // disable the "+" button, don't add if editing
        }

    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("👊 numberOfRowsInSection was just called and there are \(partyItems.count) rows in the tableView")
        return partyPlannerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("👍👍 Dequeing the table view cell for indexPath.row = \(indexPath.row) where the cell contains item \(partyItems[indexPath.row])")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = partyPlannerArray[indexPath.row].item
        cell.detailTextLabel?.text = partyPlannerArray[indexPath.row].personResponsible
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            partyPlannerArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // First make a copy of the item that you are going to move
        let itemToMove = partyPlannerArray[sourceIndexPath.row]
        // Delete item from the original location (pre-move)
        partyPlannerArray.remove(at: sourceIndexPath.row)
        // Insert item into the "to", post-move, location
        partyPlannerArray.insert(itemToMove, at: destinationIndexPath.row)
    }
    
}

