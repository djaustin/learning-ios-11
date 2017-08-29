//
//  FeedTableViewController.swift
//  instagram-clone
//
//  Created by Dan Austin on 29/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {

    var followedPosts = [PFObject]()
    let refresher = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()

        populatePostsFromFollowedUsers()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(populatePostsFromFollowedUsers), for: .valueChanged)
        
        tableView.addSubview(refresher)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @objc func populatePostsFromFollowedUsers(){
        
        print("Entered populate...")
        guard let followedUsers = try? PFUser.current()?.relation(forKey: "following").query().findObjects() else {
            print("Unable to retrive user posts")
            return
        }
        
        guard let followedUsersUnwrapped = followedUsers else {
            print("Unable to retrive user posts")
            return
        }
        print("Followed users", followedUsersUnwrapped)
        let postQuery = PFQuery(className: "Post")
        postQuery.addDescendingOrder("createdAt")
        postQuery.includeKey("author")
        postQuery.whereKey("author", containedIn: followedUsersUnwrapped)
        var posts = try? postQuery.findObjects()
        if let posts = posts {
            followedPosts.append(contentsOf: posts)
        }
        refresher.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return followedPosts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedTableViewCell
        let post = followedPosts[indexPath.row]
        let image = post["image"] as! PFFile
        image.getDataInBackground { (data, error) in
            if let data = data {
                DispatchQueue.main.async {
                    cell.postImageView.image = UIImage(data: data)
                }
            }
        }
        let author = post["author"] as? PFUser
        cell.authorLabel.text = author?.username
        cell.captionLabel.text = post["caption"] as? String
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
