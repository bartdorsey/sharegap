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
                if (attachment.hasItemConformingToTypeIdentifier("public.url")) {
                    attachment.loadItem(forTypeIdentifier: "public.url", options: nil) { data, error in
                        if error == nil {
                            let url = data as! URL
                            let parsedURL = self.parseAppleNewsURL(url)
                            NSWorkspace.shared.open(parsedURL)
                            NSLog("URL opened in Safari: %@", url.absoluteString)
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

    func parseAppleNewsURL(_ url: URL) -> URL {
        return url
    }
    
    override func viewDidLoad() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
