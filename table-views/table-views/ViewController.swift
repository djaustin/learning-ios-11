//
//  ViewController.swift
//  table-views
//
//  Created by Dan Austin on 22/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dataSource = ["Daniel", "Naomi", "Helena", "Graham"]
    
    // Determines the number of rows in a given section. We only have one section so we use the number of elements in our data souce
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return dataSource.count
        return 50
    }
    
    // Determines the cell to be shown at a given row index
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = String(indexPath.row+1)
        
        return cell
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

