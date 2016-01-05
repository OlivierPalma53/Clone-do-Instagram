//
//  TableViewController.swift
//  ParseStarterProject
//
//  Created by Olivier Palma on 02/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class TableViewController: UITableViewController {
    
    var refresher: UIRefreshControl!
    
    var usernames = [""]
    var userIds = [""]
    var isFollowing = ["":false]
    
    func refresh() {
        
        usernames.removeAll(keepCapacity: true)
        userIds.removeAll(keepCapacity: true)
        isFollowing.removeAll(keepCapacity: true)
        
        let query = PFUser.query()
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if error != nil {
                print(error)
            }
            
            if let users = objects {
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        if user.objectId! != PFUser.currentUser()?.objectId{
                            self.usernames.append(user.username!)
                            self.userIds.append(user.objectId!)
                            
                            let query = PFQuery(className: "Follower")
                            
                            query.whereKey("follower", equalTo: (PFUser.currentUser()?.objectId)!)
                            query.whereKey("following", equalTo: user.objectId!)
                            
                            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                                
                                if let objects = objects {
                                    if objects.count > 0 {
                                        self.isFollowing[user.objectId!] = true
                                    } else {
                                        self.isFollowing[user.objectId!] = false
                                    }
                                }
                                if self.isFollowing.count == self.usernames.count {
                                    self.tableView.reloadData()
                                    self.refresher.endRefreshing()
                                }
                            })
                        }
                    }
                }
            }
            
        })

    }
    
//    override func viewDidAppear(animated: Bool) {
//        if seguirUsuario == true {
//            self.performSegueWithIdentifier("feedSegue", sender: self)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Puxe para atualizar")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refresher)
        
        refresh()
        
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
        return usernames.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let userId = userIds[indexPath.row]
        if isFollowing[userId] == true {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        cell.textLabel?.text = usernames[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let userId = userIds[indexPath.row]
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!

        
        if isFollowing[userId] == true {
            
            isFollowing[userId] = false
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            let query = PFQuery(className: "Follower")
            query.whereKey("follower", equalTo: (PFUser.currentUser()?.objectId!)!)
            query.whereKey("following", equalTo: userIds[indexPath.row])
            
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if let objects = objects {
                    for object in objects{
                        object.deleteInBackground()
                    }
                }
            })
            
        } else{
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            let following = PFObject(className: "Follower")
            following["following"] = userIds[indexPath.row]
            following["follower"] = PFUser.currentUser()?.objectId
            
            following.saveInBackground()

        }
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
