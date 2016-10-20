//
//  MatchedListTableViewController.swift
//  DatingApp
//
//  Created by Hahaboy on 20/10/2016.
//  Copyright © 2016 Hahaboy. All rights reserved.
//

import UIKit
import SDWebImage

class MatchedListTableViewController: UITableViewController {
    
    var listOfMatchedUser = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.userRef.child(User.currentUserUid()!).child("like").observeEventType(.Value, withBlock: { likeSnapshot in
            
            if likeSnapshot.hasChildren(){
                let keyArray = likeSnapshot.value?.allKeys as! [String]
                
                for key in keyArray{
                    DataService.userRef.child(key).child("like").observeEventType(.Value, withBlock: { likeSnapshot2 in
                        if likeSnapshot2.hasChild(User.currentUserUid()!){
                            
                            DataService.userRef.child(key).observeEventType(.Value, withBlock: { userSnapshot in
                                if let user = User(snapshot: userSnapshot){
                                    self.listOfMatchedUser.append(user)
                                    self.tableView.reloadData()
                                }
                            })
                            
                        }
                    })
                }
            }
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfMatchedUser.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MatchCell")
        
        let user = self.listOfMatchedUser[indexPath.row]
        
        cell?.textLabel?.text = user.username
        cell?.detailTextLabel?.text = user.gender
        
        let userImageUrl = user.profileImage
        let url = NSURL(string: userImageUrl!)
        cell!.imageView!.sd_setImageWithURL(url)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            let user = self.listOfMatchedUser[indexPath.row]
            for (index,i) in self.listOfMatchedUser.enumerate(){
                if i.uid == user.uid{
                    self.listOfMatchedUser.removeAtIndex(index)
                    self.tableView.reloadData()
                }
            }
            DataService.userRef.child(User.currentUserUid()!).child("like").child(user.uid!).removeValue()
        }
    }
}
