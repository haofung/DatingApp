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
    
    var numberOfCards: UInt = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        
        kolodaView.delegate = self
        kolodaView.dataSource = self
        
        DataService.userRef.observeEventType(.ChildAdded, withBlock: { userSnapshot in
            if let user = User(snapshot: userSnapshot){
                self.listOfUser.append(user)
                self.kolodaView.reloadData()
            }
        })
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
    
//    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
////        return NSBundle.mainBundle().loadNibNamed("OverlayView",
//                                                  owner: self, options: nil)[0] as? OverlayView
//    }
    
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
    
//    func kolodaDidRunOutOfCards(koloda: KolodaView) {
//        //Example: reloading
//        kolodaView.resetCurrentCardNumber()
//    }
    
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
    
//    func kolodaBackgroundCardAnimation(koloda: KolodaView) -> POPPropertyAnimation? {
//        return nil
//    }
}
