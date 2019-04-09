//
//  ShareViewController.swift
//  Copy To Clipboard
//
//  Created by Bart Dorsey on 4/8/19.
//  Copyright © 2019 Bart Dorsey. All rights reserved.
//

import Cocoa

class ShareViewController: NSViewController {

    @IBOutlet weak var text: NSTextField!
    @IBOutlet weak var image: NSImageView!
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("ShareViewController")
    }

    override func loadView() {
        super.loadView()
    
        let item = self.extensionContext!.inputItems[0] as! NSExtensionItem
        if let attachments = item.attachments {
            for attachment in attachments {
                if (attachment.hasItemConformingToTypeIdentifier("public.image")) {
                    attachment.loadItem(forTypeIdentifier: "public.image", options: nil) { data, error in
                        if error == nil {
                            NSLog("Image = %@", data as! NSImage)
                            let image = data as! NSImage
                            self.image.image = image
                            let tiff = image.tiffRepresentation
                            let pasteboard = NSPasteboard.general
                            pasteboard.declareTypes([NSPasteboard.PasteboardType.tiff], owner: nil)
                            pasteboard.setData(tiff, forType: NSPasteboard.PasteboardType.tiff)
                            NSLog("Image copied to clipboard = %@", image)
                            let outputItems = [item]
                            self.extensionContext!.completeRequest(returningItems: outputItems, completionHandler: nil)
                        } else {
                            NSLog("No Image")
                        }
                    }
                } else if (attachment.hasItemConformingToTypeIdentifier("public.url")) {
                    NSLog("Attachments = %@", attachments as NSArray)
                    attachment.loadItem(forTypeIdentifier: "public.url", options: nil) { data, error in
                        if error == nil {
                            let url = data as! NSURL
                            if let urlString = url.absoluteString {
                                let pasteboard = NSPasteboard.general
                                pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                                pasteboard.setString(urlString, forType: NSPasteboard.PasteboardType.string)
                                NSLog("URL copied to clipboard = %@", url)
                                let outputItems = [item]
                                self.extensionContext!.completeRequest(returningItems: outputItems, completionHandler: nil)
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
        NSLog("outputItem = %@", outputItem);
        let outputItems = [outputItem]
        self.extensionContext!.completeRequest(returningItems: outputItems, completionHandler: nil)
}

    @IBAction func cancel(_ sender: AnyObject?) {
        let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        self.extensionContext!.cancelRequest(withError: cancelError)
    }

    override func viewDidLoad() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
