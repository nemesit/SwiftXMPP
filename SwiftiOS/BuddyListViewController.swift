//
//  BuddyListViewController.swift
//  SwiftiOS
//
//  Created by Felix Grabowski on 10/06/14.
//  Copyright (c) 2014 Felix Grabowski. All rights reserved.
//

import UIKit

class BuddyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChatDelegate {

  @IBOutlet var tView: UITableView
  var onlineBuddies: NSMutableArray = []
  
//  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    // Custom initialization
//  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tView.delegate = self
    tView.dataSource = self
    let delegate = appDelegate()
    delegate.chatDelegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    var login : AnyObject! = NSUserDefaults.standardUserDefaults().objectForKey("userID")
    if login {
      if appDelegate().connect() {
        //show buddy list
      } else {
        showLogin()
      }
    }
  }
  
  func showLogin() {
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let loginController : AnyObject! = storyBoard.instantiateViewControllerWithIdentifier("loginViewController")
    presentViewController(loginController as UIViewController, animated: true, completion: nil)
  }
  
  func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    var s: NSString = onlineBuddies.objectAtIndex(indexPath.row) as NSString
    let cellIdentifier = "UserCellIdentifier"
    var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
    
    if !cell {
      
      cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
//      println("cell : \(cell)")
    }
    
    if let c = cell? {
      c.textLabel.text = s
      c.accessoryType = .DisclosureIndicator
    }
    
    
//    cell!.textLabel.text = s
//    cell!.accessoryType = .DisclosureIndicator
    return cell;
  }
  
  func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
    return onlineBuddies.count
  }
  
  func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println("didSelectRowAtIndexPath")
    var userName: String? = onlineBuddies.objectAtIndex(indexPath.row) as? String
    var storyBoard = UIStoryboard(name: "Main", bundle: nil)
    var chatController: ChatViewController? = storyBoard.instantiateViewControllerWithIdentifier("chatViewController") as? ChatViewController
    if let controller = chatController? {
      controller.chatWithUser = userName!
      presentModalViewController(controller, animated: true)
    }
//    println(chatController)
  }
  
  func newBuddyOnLine(buddyName: NSString) {
    onlineBuddies.addObject(buddyName)
//    println("new buddy online: \(buddyName)")
    tView.reloadData()
  }

  func buddyWentOffline(buddyName: NSString) {
//    onlineBuddies.removeObject(buddyName)
//    tView.reloadData()
  }

  func appDelegate() -> AppDelegate {
    return UIApplication.sharedApplication().delegate as AppDelegate
  }
  
  func xmppStream () -> XMPPStream {
    return appDelegate().xmppStream!
  }
  
  func didDisconnect() {
    onlineBuddies.removeAllObjects()
    tView.reloadData()
  }

}