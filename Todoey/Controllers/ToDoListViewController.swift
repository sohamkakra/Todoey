//
//  ViewController.swift
//  Todoey
//
//  Created by Soham Kakra on 23/06/2020.
//  Copyright © 2020 Soham Kakra. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for : .documentDirectory, in : .userDomainMask).first!.appendingPathComponent("Items.plist")

        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

        print(dataFilePath)
        
        loadItems()
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    //MARK - Add new item in the list
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textfield.text!
            self.itemArray.append(newItem)
            
            self.saveItems()
            
                    }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
        }
        
        
      
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    
    }
    
    func saveItems()
    {
        let encoder = PropertyListEncoder()
        do{
                    
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath)
                    
        }catch{
            print("Error found \(Error.self)")
              }
        tableView.reloadData()
    }
        
    func loadItems() {
        if let data = try? Data(contentsOf : dataFilePath){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch  {
                print("Error found \(Error.self)")
            }
        
        }
    }
    
}

