//
//  MatchesTableViewController.swift
//  tinder-style-app
//
//  Created by Dan Austin on 08/09/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import Parse
class MatchesTableViewController: UITableViewController {

    @IBAction func backWasTapped(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    var matchedUsers = [PFUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMatchedUsers()

    }

    
    func loadMatchedUsers(){
        print("Loading matched users")
        guard let usersLikedByCurrentRelation = PFUser.current()?.relation(forKey: "accepted") else {print("returning");return}
        usersLikedByCurrentRelation.query().whereKey("accepted", equalTo: PFUser.current()!).findObjectsInBackground { (matches, error) in
            if let matches = matches as? [PFUser]{
                print("Found users")
                for user in matches {
                    print(user.username!)
                }
                self.matchedUsers = matches
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matchedUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let matchCell = cell as? MatchTableViewCell {
            print("Casted cell to custom")
            matchCell.nameLabel.text = matchedUsers[indexPath.row].username!
            if let matchImage = matchedUsers[indexPath.row]["profilePicture"] as? PFFile {
                matchImage.getDataInBackground(block: { (data, error) in
                    if let data = data {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            matchCell.profilePictureView.image = image
                            matchCell.layoutSubviews()
                        }
                        
                    }
                })
            }
            
            return matchCell
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
