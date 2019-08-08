//
//  ShareViewController.swift
//  Open In Safari
//
//  Created by Bart Dorsey on 4/8/19.
//  Copyright © 2019 Bart Dorsey. All rights reserved.
//

import Cocoa

class ShareViewController: NSViewController {
	@IBOutlet weak var URL: NSTextField!
	
	override var nibName: NSNib.Name? {
		return NSNib.Name("ShareViewController")
	}
	
	override func loadView() {
		super.loadView()
		
		let item = self.extensionContext!.inputItems[0] as! NSExtensionItem
		if let attachments = item.attachments {
			for attachment in attachments {
				if (attachment.hasItemConformingToTypeIdentifier("public.file-url")) {
					attachment.loadItem(forTypeIdentifier: "public.file-url", options: nil) { data, error in
						if error == nil {
							let fileURL = data as! URL
							_ = self.shell("open -a Terminal \"\(fileURL)\"")
							NSLog("File URL opened in Safari: %@", fileURL.absoluteString)
						}
					}
				}
			}
		} else {
			NSLog("No Attachments")
		}
		let outputItems = [item]
		self.extensionContext!.completeRequest(returningItems: outputItems, completionHandler: nil)
	}
	
	func shell(_ command: String) -> String {
		let task = Process()
		task.launchPath = "/bin/bash"
		task.arguments = ["-c", command]
		
		let pipe = Pipe()
		task.standardOutput = pipe
		task.launch()
		
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
		
		return output
	}

	override func viewDidLoad() {
		self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
	}
}
