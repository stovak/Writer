//
//  NSDocument.swift
//  WriterTests
//
//  Created by TOM STOVALL on 2/2/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Foundation
import AppKit

@objc

extension NSDocument {
    /**
    
    func exportHTML(sender: Any) {
        let savePanel = NSSavePanel.init();
        savePanel.allowedFileTypes = [ "html" ];
        savePanel.representedFilename = self.lastComponentOfFileName;
        savePanel.begin {
            (result) -> Void  in
            if (result.rawValue == NSApplication.ModalResponse.OK.rawValue) {
                let fnScript = FNScript.init(withString: self.getText());
                let htmlScript = FNHTMLScript.init(withScript: fnScript);
                let htmlString = htmlScript.html();
                
            }
        };
        
        
    }
    
    func saveFDX(sender: Any) {
        let savePanel = NSSavePanel.init();
        savePanel.allowedFileTypes = [ "fdx" ];
        savePanel.nameFieldStringValue = self.fileURL?.lastPathComponent;
        savePanel.begin {
            (result) -> Void in
            if (result.rawValue == NSApplication.ModalResponse.OK.rawValue) {
                
            }
        }
    }
    **/
}
