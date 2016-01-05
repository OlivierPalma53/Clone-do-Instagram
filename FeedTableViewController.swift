//
//  FeedTableViewController.swift
//  Instagram
//
//  Created by Olivier Palma on 08/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {
    
    var messages = [String]()
    var usernames = [String]()
    var imageFile = [PFFile]()
    var users = [String: String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let users = objects {
                for object in users {
                    
                    if let user = object as? PFUser {
                        self.users[user.objectId!] = user.username!
                    }
                    
                }
            }
        })
        
        let getFollowersUsersQuery = PFQuery(className: "Follower")
        getFollowersUsersQuery.whereKey("follower", equalTo: PFUser.currentUser()!.objectId!)
        
        getFollowersUsersQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects{
                    
                    let followedUser = object["following"] as! String
                    
                    let query = PFQuery(className: "Post")
                    
                    query.whereKey("userId", equalTo: followedUser)
                    
                    query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        if let objects = objects {
                            
                            for object in objects {
                                self.messages.append(object["message"] as! String)
                                self.imageFile.append(object["imageFile"] as! PFFile)
                                self.usernames.append(self.users[object["userId"]! as! String]!)
                                
                                self.tableView.reloadData()
                            }
                            
                        }
                    })
                    
                }
                
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return imageFile.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostCell
        
        imageFile[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
            
            if let dowloadedImage = UIImage(data: data!) {
                cell.postedImage.image = dowloadedImage
            }
            
        }
        
        cell.userName.text = usernames[indexPath.row]
        cell.message.text = messages[indexPath.row]
        
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
