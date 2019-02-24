//
//  File.swift
//  TableReadWriterMac
//
//  Created by TOM STOVALL on 2/5/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Cocoa
import Foundation

@objc

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        debugPrint("applicationDidFinishLaunching");
        
        if let referenceFile = Bundle.main.url(forResource: "Reference", withExtension: "fountain") {
            let completionHander: (NSDocument?, Bool, Error?) -> Void = {(document: NSDocument?, documentWasAlreadyOpen: Bool, error: Error?) in
                if (document != nil) {
                    document?.fileURL = referenceFile.absoluteURL;
                }
            }
            NSDocumentController.shared.openDocument(
                withContentsOf: referenceFile,
                display: true,
                completionHandler:  completionHander
            );
        };
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func showFountainSyntax(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "http://www.fountain.io/syntax#section-overview")!);
    }
    
    @IBAction func showFountainWebsite(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "http://www.fountain.io")!);
    }
    
    @IBAction func showWriterOnGitHub(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "https://github.com/HendrikNoeller/Writer-Mac")!);

    }
    
}
