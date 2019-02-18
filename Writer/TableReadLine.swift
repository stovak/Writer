//
//  TableReadLine.swift
//  WriterTests
//
//  Created by TOM STOVALL on 2/7/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Foundation


enum TableReadTextParserPatterns: String {
    case BOLD_PATTERN = "**";
    case ITALIC_PATTERN = "*";
    case UNDERLINE_PATTERN = "_";
    case NOTE_OPEN_PATTERN = "[[";
    case NOTE_CLOSE_PATTERN = "]]";
    case OMIT_OPEN_PATTERN = "/*";
    case OMIT_CLOSE_PATTERN = "*/";
    
    func length() -> Int {
        return self.rawValue.lengthOfBytes(using: .utf8);
    }
}

@objc
class TableReadLine: NSObject {
    
    public var type: TableReadLineType;
    var string: String = "";
    var position: Int;
    var numberOfPreceedingFormattingCharacters: Int = 0;
    var sceneNumber: Int?;
    
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
        return self.getLineTypeStyle().description;
    }
    
    func getLineTypeStyle() -> TableReadLineTypeStyle {
        return TableReadLineTypeStyles.byLineType(self.type);
    }
    
    func toString() -> String {
        return self.typeAsString() + ": \""  + self.string + "\"";
    }
    
    func toFDXParagraph() -> XMLElement {
        let style = TableReadLineTypeStyles.byLineType(self.type);
        let text = XMLElement(name: "Text");
        text.stringValue = self.string;
        if (style.fdxName == "TitlePage") {
            let para = XMLElement(name: "Paragraph");
            para.addChild(text);
            let toReturn = XMLElement(name: "TitlePage");
            toReturn.addChild(para);
            return toReturn;
        } else {
            let toReturn = XMLElement(name: "Paragraph");
            toReturn.setAttributesWith([
                "Type": style.fdxName
                ]);
            toReturn.addChild(text);
            return toReturn;
        }
    }
    
    func BIUNDiscovery() {
        
    }

    
}
