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
        
        // TODO: Open default file
        /*
        NSURL* referenceFile = [[NSBundle mainBundle] URLForResource:@"Reference"
            withExtension:@"fountain"];
        
        void (^completionHander)(NSDocument * _Nullable, BOOL, NSError * _Nullable) = ^void(NSDocument * _Nullable document, BOOL documentWasAlreadyOpen, NSError * _Nullable error) {
            [document setFileURL:[[NSURL alloc] init]];
        };
        [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:referenceFile
            display:YES
            completionHandler:completionHander];
     */
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
