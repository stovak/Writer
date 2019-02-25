//
//  TableReadLine.swift
//  WriterTests
//
//  Created by TOM STOVALL on 2/7/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Foundation


enum TableReadTextParserPatterns: String {
    typealias RawValue = String

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

enum TableReadBIUNDRegexPatterns: String {
    typealias RawValue = String
    
    case BOLD      = "(\\*{2})(.+?)(\\*{2})";
    case ITALIC    = "(\\*)(.+?)(\\*)";
    case UNDERLINE = "(_)(.+?)(_)";
    case NOTE      = "(\\[\\[)(.+?)(\\]\\])";
    case OMIT      = "(\\/\\*)(.+?)(\\*\\/)";

}

@objc
class TableReadLine: NSObject {
    
    public var type: TableReadLineType;
    var string: String = "";
    var position: Int;
    var numberOfPreceedingFormattingCharacters: Int = 0;
    var sceneNumber: Int = -1;
    
    var boldRanges: [ NSTextCheckingResult ] = [];
    var italicRanges: [ NSTextCheckingResult ] = [];
    var underlinedRanges: [ NSTextCheckingResult ] = [];
    var noteRanges: [ NSTextCheckingResult ] = [];
    var omitedRanges: [ NSTextCheckingResult ] = [];
    
    var omitIn: Bool = false; //wether the line terminates an unfinished omit
    var omitOut: Bool = false; //Wether the line starts an omit and doesn't finish it
    
    init(withString string: String, position: Int) {
        self.string = string;
        self.position = position;
        self.type = TableReadLineType.empty;
        super.init();
    }
    
    func typeAsString() -> String {
        return self.getLineTypeStyle().id;
    }
    
    func typeAsLabel() -> String {
        return self.getLineTypeStyle().description;
    }
    
    func getLineTypeStyle() -> TableReadLineTypeStyle {
        return TableReadLineTypeStyles.byLineType(self.type);
    }
    
    func toString() -> String {
        return self.typeAsLabel() + ": \""  + self.string + "\"";
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
    
    func toHTMLElement() -> XMLElement {
        let style = TableReadLineTypeStyles.byLineType(self.type);
        let element = XMLElement(name: style.id);
        element.stringValue = self.string;
        return element;
    }
    
    func BIUNDiscovery() {
        self.getBoldRanges();
        self.getItalicRanges();
        self.getUnderlineRanges();
        self.getNoteRanges();
        self.getOmitRanges();
    }

    func getBoldRanges() {
        do {
            let regex = try NSRegularExpression(pattern: TableReadBIUNDRegexPatterns.BOLD.rawValue, options: []);
            self.boldRanges = regex.matches(in: self.string, options: [], range: NSMakeRange(0, self.string.count));
        } catch {
            ErrorHandler.init(error);
        }
    }
    
    func getItalicRanges() {
        do {
            let regex = try NSRegularExpression(pattern: TableReadBIUNDRegexPatterns.ITALIC.rawValue, options: []);
            self.italicRanges = regex.matches(in: self.string, options: [], range: NSMakeRange(0, self.string.count));
        } catch {
            ErrorHandler.init(error);
        }
    }
    
    func getUnderlineRanges() {
        do {
            let regex = try NSRegularExpression(pattern: TableReadBIUNDRegexPatterns.UNDERLINE.rawValue, options: []);
            self.italicRanges = regex.matches(in: self.string, options: [], range: NSMakeRange(0, self.string.count));
        } catch {
            ErrorHandler.init(error);
        }
    }
    
    func getNoteRanges() {
        do {
            let regex = try NSRegularExpression(pattern: TableReadBIUNDRegexPatterns.NOTE.rawValue, options: []);
            self.italicRanges = regex.matches(in: self.string, options: [], range: NSMakeRange(0, self.string.count));
        } catch {
            ErrorHandler.init(error);
        }
    }
    
    func getOmitRanges() {
        do {
            let regex = try NSRegularExpression(pattern: TableReadBIUNDRegexPatterns.OMIT.rawValue, options: []);
            self.italicRanges = regex.matches(in: self.string, options: [], range: NSMakeRange(0, self.string.count));
        } catch {
            ErrorHandler.init(error);
        }
    }
    
}
