//
//  TableViewController.swift
//  memorable-places
//
//  Created by Dan Austin on 23/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import MapKit

class TableViewController: UITableViewController {

    var places = [MKPointAnnotation]()
    var pointToShowOnMap: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        populateDataSourceFromUserDefaults()
        print(places)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Populate the local datasource variable with saved values in UserDefaults if any exist
    func populateDataSourceFromUserDefaults(){
        if let savedPlaces = UserDefaults.standard.object(forKey: "memorable_places") as? [[String:Any]] {
            places = savedPlaces.map({ (ele) -> MKPointAnnotation in
                MKPointAnnotation(fromDictionary: ele)
            })
        } else {
            places = []
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].title
        return cell
    }
  
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove from data source
            places.remove(at: indexPath.row)
            // Delete table row
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Save row selected
        pointToShowOnMap = places[indexPath.row]
        // Begin segue to map view controller
        performSegue(withIdentifier: "toMap", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Save datasource
        UserDefaults.standard.set(places.map({ e in
            e.toDictionary()
        }), forKey: "memorable_places")
        if segue.identifier == "toMap"{
            let vc = segue.destination as! ViewController
            // Store selected annotation in variable on map view controller
            vc.pointToShow = pointToShowOnMap
        }
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
