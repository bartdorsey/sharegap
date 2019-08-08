//
//  AppDelegate.swift
//  sharegap
//
//  Created by Bart Dorsey on 4/8/19.
//  Copyright © 2019 Bart Dorsey. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
		showNotification(title: "Share Gap", informativeText: "Please activate the new Share Menu items")
	}
	
	func showNotification(title: String, informativeText: String) -> Void {
		let notification = NSUserNotification()
		
		notification.title = title
		notification.informativeText = informativeText
		notification.soundName = NSUserNotificationDefaultSoundName
		
		NSUserNotificationCenter.default.deliver(notification)
	}
	
	func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
		return true
	}

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

