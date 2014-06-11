//
//  ChatDelegate.swift
//  SwiftiOS
//
//  Created by Felix Grabowski on 10/06/14.
//  Copyright (c) 2014 Felix Grabowski. All rights reserved.
//

import Foundation

protocol ChatDelegate {
  func newBuddyOnLine(buddyName: NSString)
  func buddyWentOffline(buddyName: NSString)
  func didDisconnect()
}
