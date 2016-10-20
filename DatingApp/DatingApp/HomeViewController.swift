//
//  HomeViewController.swift
//  DatingApp
//
//  Created by Hahaboy on 20/10/2016.
//  Copyright © 2016 Hahaboy. All rights reserved.
//

import UIKit
import Koloda

class HomeViewController: UIViewController, KolodaViewDelegate, KolodaViewDataSource {

    @IBOutlet weak var kolodaView: KolodaView!
    var listOfUser = [User]()
    var likedAndDisliked = [String]()
    var listOfFemale = [User]()
    var listOfMale = [User]()
    var listOfmix = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        
        kolodaView.delegate = self
        kolodaView.dataSource = self
        
        removeLikedUser()
        removeDislikeUser()
        
        addFilterUser()
        
       
    }
    func removeLikedUser(){
    //add like user into array
            DataService.userRef.child(User.currentUserUid()!).child("like").observeEventType(.Value, withBlock: { likeSnapshot in
                if likeSnapshot.hasChildren(){
                    let keyArray = likeSnapshot.value?.allKeys as! [String]
                    for key in keyArray{
                        self.likedAndDisliked.append(key)
                    }
    
                    
                }
            })
    }
    
    func removeDislikeUser(){
        //add dislike user into array
        DataService.userRef.child(User.currentUserUid()!).child("dislike").observeEventType(.Value, withBlock: { dislikeSnapshot in
            if dislikeSnapshot.hasChildren(){
                let keyArray = dislikeSnapshot.value?.allKeys as! [String]
                for key in keyArray{
                    self.likedAndDisliked.append(key)
                }
            }
        })
    }
    
    func addFilterUser(){
        //add filter user
        DataService.userRef.observeEventType(.ChildAdded, withBlock: { userSnapshot in
            if let user = User(snapshot: userSnapshot){
                if user.uid != User.currentUserUid(){
                    if !self.likedAndDisliked.contains(user.uid!){
                        self.listOfUser.append(user)
                        self.listOfmix.append(user)
                        self.kolodaView.reloadData()
                    }
                }
            }
            self.filterMaleAndFemale()
        })
    }

    func filterMaleAndFemale(){
        for i in self.listOfUser{
            if i.gender == "male"{
                self.listOfMale.append(i)
            }else if i.gender == "female"{
                self.listOfFemale.append(i)
            }
        }
    }
    
    @IBAction func onFilterButtonPressed(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Filter", message: "Select filter option", preferredStyle: UIAlertControllerStyle.Alert)
        
        let maleAction = UIAlertAction(title: "Male", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            self.listOfUser = self.listOfMale
            self.kolodaView.reloadData()
            
        }
        
        let femaleAction = UIAlertAction(title: "Female", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            self.listOfUser = self.listOfFemale
            self.kolodaView.reloadData()
            
        }
        
        let allAction = UIAlertAction(title: "Mix", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            self.listOfUser = self.listOfmix
            self.kolodaView.reloadData()
            
        }
        
        alertController.addAction(maleAction)
        alertController.addAction(femaleAction)
        alertController.addAction(allAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func left(sender: AnyObject) {
        kolodaView?.swipe(SwipeResultDirection.Left)
        
    }
    
    @IBAction func right(sender: AnyObject) {
        kolodaView?.swipe(SwipeResultDirection.Right)
        
    }
    
    @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue) {
    }
    
    //MARK: KolodaViewDataSource
    
    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        return UInt(self.listOfUser.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        let header = NSBundle.mainBundle().loadNibNamed("StaticView", owner: 0, options: nil)[0] as? StaticView
        let user = self.listOfUser[Int(index)]
        
        if let username = user.username{
            header?.userNameLabel.text = username
        }
        
        if let userImageUrl = user.profileImage{
            
            let url = NSURL(string: userImageUrl)
            
            header!.userImageView!.sd_setImageWithURL(url)
            header!.userImageView!.layer.cornerRadius = 25
            header!.userImageView!.clipsToBounds = true
        }
        
        
        return header!
        
    }
    
    
    //MARK: KolodaViewDelegate
    
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
        //Example: loading more cards
        
        let user = self.listOfUser[Int(index)]
        
        if direction.hashValue == 0{
            print("left")
            
            DataService.userRef.child(User.currentUserUid()!).child("dislike").updateChildValues([user.uid!: true])
            
        }else if direction.hashValue == 1{
            print("right")
            
            DataService.userRef.child(User.currentUserUid()!).child("like").updateChildValues([user.uid!: true])
        }
    }
    
    func kolodaDidSelectCardAtIndex(koloda: KolodaView, index: UInt) {
        
    }
    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldTransparentizeNextCard(koloda: KolodaView) -> Bool {
        return true
    }
    
}
