//
//  ViewController.swift
//  todo-list
//
//  Created by Dan Austin on 22/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var dataSource = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        // Check to avoid array index out of bounds
        if dataSource.count > indexPath.row{
            cell.textLabel?.text = dataSource[indexPath.row]
        }
        
        return cell
    }
    
    // If this is added, the UI allows table rows to be swiped left to expose a delet button
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete{
            dataSource.remove(at: indexPath.row)
            tableView.reloadData()
            UserDefaults.standard.set(dataSource, forKey: "user_todos")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load Data
        dataSource = getSavedTodos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getSavedTodos() -> [String] {
        if let todos = UserDefaults.standard.stringArray(forKey: "user_todos") {
            return todos
        } else {
            return []
        }
    }
    
}

