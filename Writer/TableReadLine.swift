//
//  TableReadLine.swift
//  WriterTests
//
//  Created by TOM STOVALL on 2/7/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Foundation

@objc
class TableReadLine: NSObject {
    
    var type: TableReadLineType?;
    var string: String = "";
    let position: Int;
    var numberOfPreceedingFormattingCharacters: Int = 0;
    var sceneNumber: String?;
    
    var boldRanges: NSMutableSet? = nil;
    var italicRanges: NSMutableSet? = nil;
    var underlinedRanges: NSMutableSet? = nil;
    var noteRanges: NSMutableSet? = nil;
    var omitedRanges: NSMutableSet? = nil;
    
    var omitIn: Bool = false; //wether the line terminates an unfinished omit
    var omitOut: Bool = false; //Wether the line starts an omit and doesn't finish it
    
    init(withString string: String, position: Int) {
        self.string = string;
        self.position = position;
        self.type = TableReadLineType.empty;
        super.init();
    }
    
    func typeAsString() -> String {
        if (self.type != nil) {
            return TableReadLineTypeStyles.byLineType(self.type).description;
        }
    }
}

@objc
class Line: TableReadLine { }
