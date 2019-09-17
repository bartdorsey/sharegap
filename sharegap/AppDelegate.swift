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
		showNotification(title: "Installed OK", informativeText: "Please activate your new Share Menu items")
	}
	
	func showNotification(title: String, informativeText: String) -> Void {
		let notification = NSUserNotification()
		notification.title = "Share Gap"
		notification.informativeText = "Please activate the new Share Menu items in System Preferences."
		notification.hasActionButton = true
		notification.actionButtonTitle = "Open"

		NSUserNotificationCenter.default.delegate = self
		NSUserNotificationCenter.default.deliver(notification)
	}
	
	func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
		return true
	}
	
	func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
		switch (notification.activationType) {
//		case .replied:
//			guard let res = notification.response else { return }
//			print("User replied: \(res.string)")
//		case .additionalActionClicked:
//			guard let choosen = notification.additionalActivationAction, let title = choosen.title else { return }
//			print("Action: \(title)")
		case .actionButtonClicked:
			let prefpaneUrl = URL(fileURLWithPath: "/System/Library/PreferencePanes/Extensions.prefPane")
			NSWorkspace.shared.open(prefpaneUrl)
			
//		case .contentsClicked:
//			let prefpaneUrl = URL(string: "x-apple.systempreferences:")!
//			NSWorkspace.shared.open(prefpaneUrl)
		default:
			break;
		}
	}

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

