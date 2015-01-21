//
//  UserTableViewController.swift
//  InstaDownloader
//
//  Created by Ekrem Doğan on 19.01.2015.
//  Copyright (c) 2015 Ekrem Doğan. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    var users:[String] = []
    var usersImFollowing:[String] = []
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        println(PFUser.currentUser())
        
        updateUsers()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
    }
    
    func updateUsers() {
        var query = PFUser.query()
        
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            
            self.users.removeAll(keepCapacity: true)
            
            for object in objects {
                
                var user:PFUser = object as PFUser
                
                if user.username != PFUser.currentUser().username {
                    
                    self.users.append(user.username)
                }
            }
            
            self.tableView.reloadData()
        })
        
        var query2 = PFQuery(className:"followers")
        query2.whereKey("follower", equalTo: PFUser.currentUser().username)
        query2.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if error == nil {
                self.usersImFollowing.removeAll(keepCapacity: true)
                for var i = 0; i < objects.count; i++ {
                    
                    var user: PFObject = objects[i] as PFObject
                    var following = user.valueForKey("following") as NSString
                    self.usersImFollowing.append(following)
                }
                
            } else {
                
                println(error)
            }
            println(self.usersImFollowing)
            self.tableView.reloadData()
            self.refresher.endRefreshing()
        }
    }
    
    func refresh() {
        println("refreshed")
        
        updateUsers()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        cell.textLabel?.text = users[indexPath.row]
        
        if (usersImFollowing.count == 0) {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        for var i = 0; i < usersImFollowing.count; i++ {
            
            if usersImFollowing[i] == users[indexPath.row] {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            var query = PFQuery(className:"followers")
            query.whereKey("follower", equalTo: PFUser.currentUser().username)
            query.whereKey("following", equalTo: cell.textLabel?.text)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                
                if error == nil {
                    
                    for object in objects {
                        
                        object.deleteInBackgroundWithTarget(nil, selector: nil)
                    }
                } else {
                    
                    println(error)
                }
            }
        }
        else {

            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            var following = PFObject(className: "followers")
            
            following["following"] = cell.textLabel?.text
            following["follower"] = PFUser.currentUser().username
            
            following.saveInBackgroundWithTarget(nil, selector: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
