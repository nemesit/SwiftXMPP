//
//  AppDelegate.swift
//  SwiftXMPP
//
//  Created by Felix Grabowski on 10/06/14.
//  Copyright (c) 2014 Felix Grabowski. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, XMPPStreamDelegate {
                            
  var window: UIWindow?
  var viewController: BuddyListViewController?
  var password: NSString?
  var isOpen: Bool = false
  var xmppStream: XMPPStream?
  var chatDelegate: ChatDelegate?
  var messageDelegate: MessageDelegate?
  var loginServer: String = ""

  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
    // Override point for customization after application launch.
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    self.connect()
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
  func setupStream () {
    xmppStream = XMPPStream()
    xmppStream!.addDelegate(self, delegateQueue: dispatch_get_main_queue())
  }
  
  func goOffline() {
    var presence = XMPPPresence(type: "unavailable")
    xmppStream!.sendElement(presence)
  }
  
  func goOnline() {
    println("goOnline")
    var presence = XMPPPresence()
    xmppStream!.sendElement(presence)
  }

  func connect() -> Bool {
    println("connecting")
    setupStream()
    
    //NSUserDefaults.standardUserDefaults().setValue("8grabows@jabber.mafiasi.de", forKey: "userID")
    let b = NSUserDefaults.standardUserDefaults().stringForKey("userID")
    println("user defaults: " + "\(b)")
    
    var jabberID: String? = NSUserDefaults.standardUserDefaults().stringForKey("userID")
    var myPassword: String? = NSUserDefaults.standardUserDefaults().stringForKey("userPassword")
    var server: String? = NSUserDefaults.standardUserDefaults().stringForKey("loginServer")
    if server {
      loginServer = server!
    }

    
    if let stream = xmppStream? {
      if !stream.isDisconnected() {
        return true
      }
      
      if !jabberID || !myPassword {
        println("no jabberID set:" + "\(jabberID)")
        println("no password set:" + "\(myPassword)")
        return false
      }
      
      stream.myJID = XMPPJID.jidWithString(jabberID)
      password = myPassword
      
      var error: NSError?
      if !stream.connectWithTimeout(XMPPStreamTimeoutNone, error: &error) {
        var alertView: UIAlertView? = UIAlertView(title:"Error", message: "Cannot connect to \(error!.localizedDescription)", delegate: nil, cancelButtonTitle: "Ok")
        alertView!.show()
        
        return false
      }
    }
    return true
  }
  
  func disconnect() {
    goOffline()
    xmppStream!.disconnect()
//    println("disconnecting")
  }
  
  
  func xmppStreamDidConnect(sender: XMPPStream) {
//    println("xmppStreamDidConnect")
    isOpen = true
    var error: NSError?
    if xmppStream!.authenticateWithPassword(password, error: &error) {
//      println("authentification successful")
    }
  }
  
  func xmppStreamDidAuthenticate(sender: XMPPStream) {
//    println("didAuthenticate")
    goOnline()
  }
  
  func xmppStream(sender: XMPPStream?, didReceiveMessage: XMPPMessage?) {
    if let message = didReceiveMessage? {
      if let msg: String = message.elementForName("body").stringValue() {
        if let from: String = message.attributeForName("from").stringValue() {
          var m: NSMutableDictionary = [:]
          m["msg"] = msg
          m["sender"] = from
          println("messageReceived")
          messageDelegate?.newMessageReceived(m)
        }
      } else { return }
    }
  }
  
  func xmppStream(sender: XMPPStream?, didReceivePresence: XMPPPresence?) {
//    println("didReceivePresence")
    
    if let presence = didReceivePresence? {
      var presenceType = presence.type()
      var myUsername = sender?.myJID.user
      var presenceFromUser = presence.from().user
      if chatDelegate != nil {
//        println(chatDelegate)
        if presenceFromUser != myUsername {
          if presenceType == "available" {
            chatDelegate?.newBuddyOnLine("\(presenceFromUser)" + "@" + "\(loginServer)")
          } else if presenceType == "unavailable" {
            chatDelegate?.buddyWentOffline("\(presenceFromUser)" + "@" + "\(loginServer)")
          }
        }
      }
//      println(presenceType)
    }
    
    
  }
  
  
}


