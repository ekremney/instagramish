//
//  feedViewController.swift
//  InstaDownloader
//
//  Created by Ekrem Doğan on 20.01.2015.
//  Copyright (c) 2015 Ekrem Doğan. All rights reserved.
//

import UIKit

class feedViewController: UITableViewController {
    
    var titles = [String]()
    var usernames = [String]()
    var images = [UIImage]()
    var imageFiles = [PFFile]()

    override func viewDidLoad() {
        super.viewDidLoad()

        var getFollowedUserQuery = PFQuery(className: "followers")
        getFollowedUserQuery.whereKey("follower", equalTo: PFUser.currentUser().username)
        getFollowedUserQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if error == nil {
                
                var followedUser = ""
                
                for object in objects {
                    println("11")
                    
                    followedUser = object["following"] as String
                    
                    var query = PFQuery(className:"posts")
                    query.whereKey("username", equalTo: followedUser)
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]!, error: NSError!) -> Void in
                        if error == nil {
                            
                            println("Successfully retrieved \(objects.count) objects.")
                            
                            for var i = 0; i < objects.count; i++ {
                                
                                self.titles.append(objects[i]["title"] as String)
                                self.usernames.append(objects[i]["username"] as String)
                                self.imageFiles.append(objects[i]["imageFile"] as PFFile)
                                
                                self.tableView.reloadData()
                            }
                        } else {
                            
                            println(error)
                        }
                    }
                }
            }
            
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return titles.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 260
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell: Cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as Cell
        
        myCell.title.text = titles[indexPath.row]
        myCell.username.text = usernames[indexPath.row]
        
        imageFiles[indexPath.row].getDataInBackgroundWithBlock({ (imageData: NSData!, error: NSError!) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData)
                myCell.postedImage.image = image
            }
            
        })

        return myCell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
