//
//  ShareViewController.swift
//  copytoclipboard
//
//  Created by Bart Dorsey on 4/8/19.
//  Copyright © 2019 Bart Dorsey. All rights reserved.
//

import Cocoa

class ShareViewController: NSViewController {

    @IBOutlet weak var text: NSTextField!
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("ShareViewController")
    }

    override func loadView() {
        super.loadView()
    
        // Insert code here to customize the view
        let item = self.extensionContext!.inputItems[0] as! NSExtensionItem
        if let attachments = item.attachments {
            for attachment in attachments {
                if (attachment.hasItemConformingToTypeIdentifier("public.url")) {
                    NSLog("Attachments = %@", attachments as NSArray)
                    attachment.loadItem(forTypeIdentifier: "public.url", options: nil) { data, error in
                        if error == nil {
                            let url = data as! NSURL
                            let urlString = url.absoluteString
                            NSLog("URL = %@", url)
                            if urlString != nil {
                                self.text.stringValue = urlString!
                            }
                        }
                    }
                }
            }
        } else {
            NSLog("No Attachments")
        }
    }

    @IBAction func send(_ sender: AnyObject?) {
        let outputItem = NSExtensionItem()
        // Complete implementation by setting the appropriate value on the output item
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(text.stringValue, forType: NSPasteboard.PasteboardType.string)
    
        let outputItems = [outputItem]
        self.extensionContext!.completeRequest(returningItems: outputItems, completionHandler: nil)
}

    @IBAction func cancel(_ sender: AnyObject?) {
        let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        self.extensionContext!.cancelRequest(withError: cancelError)
    }

}
