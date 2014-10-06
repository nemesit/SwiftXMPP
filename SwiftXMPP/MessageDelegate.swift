//
//  MessageDelegate.swift
//  SwiftXMPP
//
//  Created by Felix Grabowski on 10/06/14.
//  Copyright (c) 2014 Felix Grabowski. All rights reserved.
//

import Foundation

protocol MessageDelegate {
  func newMessageReceived(messageContent: NSDictionary)
}
