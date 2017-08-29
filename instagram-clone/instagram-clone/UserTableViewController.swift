//
//  UserTableViewController.swift
//  instagram-clone
//
//  Created by Dan Austin on 26/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import Parse
class UserTableViewController: UITableViewController {

    let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    let refresher = UIRefreshControl()

    var users = [PFUser]()
    var usersFollowed = [PFUser]()
    @IBAction func logoutWasPressed(_ sender: UIBarButtonItem) {
        PFUser.logOut()
        navigationController?.popViewController(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateTableWithUsernames()
        indicator.center = view.center
        indicator.activityIndicatorViewStyle = .gray
        view.addSubview(indicator)
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(populateTableWithUsernames), for: .valueChanged)
        
        tableView.addSubview(refresher)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @objc func populateTableWithUsernames(){
        
        // Get all users other than the currently logged in user
        let query = PFUser.query()?.whereKey("objectId", notEqualTo: PFUser.current()?.objectId as Any)
        
        query?.findObjectsInBackground(block: { (results, error) in
            if let results = results{
                self.users.removeAll()
                for object in results{
                    print(object)
                    if let user = object as? PFUser{
                        self.users.append(user)
                    }
                }
                
                self.tableView.reloadData()
                
            } else {
                if let error = error {
                    print("Error:", error.localizedDescription)
                }
            }
        })
        
        // Get list of users that logged in user is following
        let relation = PFUser.current()?.relation(forKey: "following")
        relation?.query().findObjectsInBackground(block: { (results, error) in
            if let results = results {
                self.usersFollowed.removeAll()
                for result in results {
                    if let user = result as? PFUser{
                        self.usersFollowed.append(user)
                    }
                    
                    DispatchQueue.main.async {
                        // Reload table now that we have retrieved the follower information
                        self.tableView.reloadData()
                        // Stop the pull-to-update animation
                        self.refresher.endRefreshing()
                    }
                }
            } else {
                if let error = error {
                    print("Error:", error.localizedDescription)
                }
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let userAtCell = users[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = userAtCell.username
    
        let userFollowed = usersFollowed.contains { (user) -> Bool in
            user.objectId == userAtCell.objectId
        }
        
        cell.accessoryType = userFollowed ? .checkmark : .none
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let userAtCell = users[indexPath.row]
        let userFollowed = usersFollowed.contains { (user) -> Bool in
            user.objectId == userAtCell.objectId
        }

        if userFollowed{
            unfollowUser(userAtCell)
            cell?.accessoryType = .none
        } else {
            followUser(userAtCell)
            cell?.accessoryType = .checkmark
        }
    }
    
    
    func unfollowUser(_ userToUnfollow: PFUser){
        pauseApplication()
        let currentUser = PFUser.current()
        let following = currentUser?.relation(forKey: "following")
        let index = usersFollowed.index { (user) -> Bool in
            user.objectId == userToUnfollow.objectId
        }
        guard let userIndex = index else {
            return
        }
        
        following?.remove(userToUnfollow)
        currentUser?.saveInBackground(block: { (success, error) in
            self.resumeApplication()
            if(success){
                self.usersFollowed.remove(at: userIndex)
            } else {
                if let error = error {
                    print("Error:", error.localizedDescription)
                }
            }
        })
    }
    
    func followUser(_ userToFollow: PFUser){
        pauseApplication()
        let currentUser = PFUser.current()
        let following = currentUser?.relation(forKey: "following")
        
        following?.add(userToFollow)
        
        currentUser?.saveInBackground(block: { (success, error) in
            self.resumeApplication()
            if success {
                self.usersFollowed.append(userToFollow)
            } else {
                if let error = error {
                    print("Error:", error.localizedDescription)
                }
            }
        })
    }
    
    func pauseApplication(){
        indicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    func resumeApplication(){
        indicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
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
