//
//  ContinuousFountainParser.swift
//  WriterTests
//
//  Created by Tom Stovall on 2/9/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Foundation
import Cocoa

@objc
class ContinousFountainParser : NSObject {
    
    var lines: [ TableReadLine ] = [];
    var changedIndices: NSMutableArray = [];
    
    var changeInOutline: Bool?;
    
    init(withString string: String) {
        NSLog("CFP Init With String");
        super.init();
        self.parseText(string);
    }
    
    func parseText(_ text: String) {
        let rawLines = text.components(separatedBy: "\n");
        var position = 0;
        for rawLine in rawLines {
            let index = self.lines.count;
            var line = TableReadLine.init(withString: rawLine, position: position);
            self.parseTypeAndFormatting(forLine:&line,  atIndex:index);
            self.lines.append(line);
            self.changedIndices.add(index);
            position = rawLine.lengthOfBytes(using: String.Encoding.utf8) + 1;
        }
        self.changeInOutline = true;
        
    }
    
    func parseChange(inRange range: NSRange, withString string: String) {
        var changed = IndexSet();
        if (range.length == 0){  //Addition
            for i in 0..<string.lengthOfBytes(using: String.Encoding.utf8) {
                let addRange = Range.init( NSMakeRange(i, 1), in: string);
                if (addRange != nil) {
                    let char = String(string[addRange!]);
                    changed.formUnion(self.parseCharacterAdded( char, atPosition: range.location + 1));
                } else {
                    NSLog("Range for string add: \(string) is invalid.");
                }
            }
        } else if (string.lengthOfBytes(using: String.Encoding.utf8) == 0) {
            for _ in 0..<range.length { //Removal
                if let indexSet = self.parseCharacterRemoved(atPosition: range.location) {
                    changed.formUnion(indexSet);
                }
            }
        } else {
            
            for _ in 0..<range.length { // first remove
                if let indexSet = self.parseCharacterRemoved(atPosition: range.location) {
                    changed.formUnion(indexSet);
                }
            }
            
            for i in 0..<string.lengthOfBytes(using: String.Encoding.utf8) { // then add
                let addRange = Range.init(NSMakeRange(i, 1), in: string);
                if (addRange != nil) {
                    let char = String(string[addRange!]);
                    changed.formUnion(self.parseCharacterAdded(char, atPosition: range.location + 1));
                } else {
                    NSLog("Range for string replace: \(string) is invalid.");
                }
                
            }
        }
        self.correctParses(inLines: changed);
    }
    
    func parseCharacterAdded(_ character: String, atPosition position: Int) -> IndexSet {
        let lineIndex = self.lineIndex(atPosition: position);
        let line = self.lines[lineIndex];
        let indexInLine = position - line.position;
        if (character == "\n") {
            var cutOffString = "";
            if (indexInLine == line.string.lengthOfBytes(using: String.Encoding.utf8) ) {
                cutOffString = "";
            } else {
                cutOffString = line.string[indexInLine];
                line.string = line.string[indexInLine];
            }
            var newline = Line.init(withString: cutOffString, position: lineIndex + 1);
            self.lines.insert(newLine, atIndex: lineIndex + 1);
            self.incrementLinePositions(fromIndex:lineIndex + 2, amount: 1);
            return IndexSet.init(integersIn: NSMakeRange(lineIndex, 2));
        } else {
            let pieces = [
                line.string.subString(toIndex: indexInLine),
                character,
                line.string.substring(fromIndex: indexInLine)
            ];
            line.string = pieces.joined(byString: "");
            self.incrementLinePosition(fromIndex: lineIndex + 1, amount: 1);
            return IndexSet.init(integer: lineIndex);
        }
    }

    func parseCharacterRemoved(atPosition position: Int) -> IndexSet? {
        let lineIndex = self.lineIndex(atPosition: position);
        let line = self.lines[lineIndex];
        let indexInLine = position - line.position;
        if (indexInLine == line.string.lengthOfBytes(using: String.Encoding.utf8)) {
            if (lineIndex == ( self.lines.count - 1 )) {
                return nil; //Removed newline at end of document without there being an empty line - should never happen but be sure...
            }
            let nextLine = self.lines[lineIndex + 1];
            line.string = line.string.appending(nextLine.string);
            if (nextLine.getLineTypeStyle().changesOutline == true) {
                self.changeInOutline = true;
            }
            self.lines.remove(at: lineIndex + 1);
            self.decrementLinePositions(fromIndex: lineIndex + 1, amount: 1);
            
            
            
        } else {
            
        }
        
        
        
        
        
        
        
        
        
    }

    func lineIndex(atPosition position: Int) -> Int {
        for i in 0..<self.lines.count {
            let line = self.lines[i];
            if (line.position < position) {
                return i-1;
            }
        }
        return self.lines.count - 1;
    }
    
    func incrementLinePositions(fromIndex index: Int, amount: Int) {
        for i in index...self.lines.count {
            let line = self.lines[i];
            line.position += amount;
        }
    }
    
    func decrementLinePositions(fromIndex index: Int, amount: Int) {
        for i in index...self.lines.count {
            let line = self.lines[i];
            line.position -= amount;
        }
    }
    
    func correctParses(
            inLines lineIndices: IndexSet
        ) {
        var localCopy = lineIndices;
        while localCopy.count > 0 {
            let removed = localCopy.remove(localCopy.min()!);
            if (removed != nil) {
                self.correctParse(inLine: removed!, indicesToDo: localCopy);
            }
        }
     }

    func correctParse(
            inLine index: Int,
            indicesToDo indices: IndexSet
        ) {
        
        var currentLine = self.lines[index];
        let oldOmitOut = currentLine.omitOut;
        let oldLineTypeStyle = currentLine.getLineTypeStyle();
        self.parseTypeAndFormatting(forLine: &currentLine, atIndex: index);
        let currentLineTypeStyle = currentLine.getLineTypeStyle();
        if (self.changeInOutline != nil &&
            (oldLineTypeStyle.changesOutline || currentLineTypeStyle.changesOutline)) {
            self.changeInOutline = true;
        }
        self.changedIndices.add(index);
        if (oldLineTypeStyle.id != currentLineTypeStyle.id || oldOmitOut != currentLine.omitOut) {
            if (index < ( self.lines.count - 1)) {
                let nextLine = self.lines[index + 1];
                let nextLineTypeStyle = nextLine.getLineTypeStyle();
                if (
                    currentLineTypeStyle.includeNextLine == true ||
                    nextLineTypeStyle.includeNextLine == true
                ) {
                    self.correctParse(inLine: index + 1, indicesToDo: indices);
                }
            }
        }
    }
    
    func parseTypeAndFormatting(
            forLine line: inout TableReadLine,
            atIndex index: Int
        ) {
        
    }
    
    func parseLineType(
            forLine line: TableReadLine,
            atIndex index: Int
        ) -> TableReadLineType {
        
    }
    
    func rangesInChars(_
            string: unichar,
            ofLength length: Int,
            between startString: Character,
            and endString: Character,
            withLength delimLength: Int,
            excludingIndices excludes: IndexSet
        ) -> NSMutableIndexSet {
        
        
        
    }
    
    func rangesOfOmitChars(_
            string: unichar,
            ofLength length: Int,
            inLine line: TableReadLine,
            lastLineOmitOut lastLineOut: Bool,
            saveStarsIn stars: NSMutableIndexSet
        ) -> NSMutableIndexSet {
        
    }
    
    func sceneNumber(
            forChars string: unichar,
            ofLength length: Int
        ) -> NSRange {
        
    }
    
    func string(atLine lineNum: Int) -> String {
        
    }
    
    func type(atLine lineNum: Int) -> TableReadLineType {
        
    }
    
    func position(atLine lineNum: Int) -> String {
        
    }
    
    func sceneNumber(atLine lineNum: Int) -> String {
        
    }
    
    func numberOfOutlineItems() -> Int {
        
    }
    
    func outlineItem(atIndex index: Int) -> TableReadLine {
        
    }
    
    func getAndResetChangeInOutline() -> Bool {
        if (self.changeInOutline != nil) {
            self.changeInOutline = false;
            return true;
        }
        return false;
    }
    
    func description() -> String {
        var result: String = "";
        var index = 0;
        for line in self.lines {
            if (index == 0) {
                result = result.appending("0 ");
            } else {
                result = result.appending(String.init(format: "%lu ", index));
            }
            result = result.appending(line.toString()).appending("\n");
        }
        return result;
    }
    
}
