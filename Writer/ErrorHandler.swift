//
//  ErrorHandler.swift
//  TableRead
//
//  Created by TOM STOVALL on 1/13/19.
//  Copyright © 2019 TOM STOVALL. All rights reserved.
//

import Foundation

class ErrorHandler {
    
    
    init(_ error: NSError) {
        printToLog(error);
    }
    
    init(_ error: Error) {
        printToLog(error as NSError);
        
    }
    
    func printToLog(_ error: NSError) {
        print("!!!!!======= Unable to Save Changes of Private Managed Object Context")
        print("\(error), \(error.localizedDescription)");
        guard let Fail = NSClassFromString("XCTFail") else {
            return;
        }
    }
    
}
