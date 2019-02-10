//
//  ContinuousFountainParser.swift
//  WriterTests
//
//  Created by Tom Stovall on 2/9/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Foundation
import Cocoa

class ContinousFountainParser : NSObject {
    
    var lines: [ TableReadLine ] = [];
    var changedIndices: NSMutableArray = [];
    
    var changeInOutline: Bool?;
    
    lazy let description = {
        let result = "";
        let index = 0;
        for line in self.lines {
            if (index == 0) {
                result = result.append("0 ");
            } else {
                result = result.append(String.init(format: "%lu ", index));
            }
            result = result.append(line.toString()).append("\n");
        }
        return result;
    }()
    
    
    init(withString: String) {
        NSLog("CFP Init With String");
        super.init();
        self.parseText(string);
    }
    
    func parseText(_ text: String) {
        self.lines = text.componentsSeparatedByString("\n");
        var position = 0;
        for rawLine in self.lines {
            let index = self.lines.count;
            let line = TableReadLine.initWithString(rawLine, position: position);
            self.parseTypeAndFormatting(forLine:line,  atIndex:index);
            self.lines.addObject(line);
            self.changedIndices.addObject(index);
            position = rawLine.length + 1;
        }
        self.changeInOutline = true;
        
    }
    
    func parseChange(inRange range: NSRange, withString string: String) {
        self.changedIndices = NSMutableIndexSet();
        if (range.length == 0){  //Addition
            for i in 0..<string.lengthOfBytes(using: String.Encoding.utf8) {
                let char = string.substring(with: NSMakeRange(i, 1));
                self.changedIndices.add(self.parseCharacterAdded( char, atPosition: range.location + 1));
            }
        } else if (string.lengthOfBytes(using: String.Encoding.utf8) == 0) {
            for i in 0..<range.length { //Removal
                self.changedIndices.add(self.parseCharacterRemoved(char, atPosition: range.location));
            }
        } else {
            
            for i in 0..<range.length { // first remove
                self.changedIndices.add(self.parseCharacterRemoved(char, atPosition: range.location))
            }
            
            for i in 0..<string.lengthOfBytes(using: String.Encoding.utf8) { // then add
                let char = string.rangeOfCharacter(from: String.Encoding.utf8, options: nil, range: NSMakeRange(i, 1));
                self.changedIndices.add(self.parseCharacterAdded(char, atPosition: range.location + 1));
            }
        }
        self.correctParsesInLines(self.changedIndices);
    }
    
    func parseCharacterAdded(_ character: String, atPosition position: Int) -> IndexSet {
        let lineIndex = self.lineIndex(atPosition, position: position);
        let line = self.lines[lineIndex];
        let indexInLine = position - line.position;
        if (character == "\n") {
            var cutOffString = "";
            if (indexInLine == line.string.length ) {
                cutOffString = "";
            } else {
                cutOffString = line.string.substring(fromIndex: indexInLine);
                line.string = line.string.substring(toIndex: indexInLine);
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

    func parseCharacterRemoved(atPosition position: Int) -> NSIndexSet? {
        let lineIndex = self.lineIndex(atPosition: position);
        let line = self.line[lineIndex];
        let indexInLine = position-line.position;
        if (indexInLine == line.string.lengthOfBytues(String.Encoding.utf8)) {
            if (lineIndex == ( self.lines.count - 1 )) {
                return nil; //Removed newline at end of document without there being an empty line - should never happen but be sure...
            }
            let nextLine = self.lines[lineIndex + 1];
            line.string = line.string.append(nextLine.string);
            
            
        }
        
        
        
        
        
        
        
        
        
    }

    func lineIndex(atPosition position: Int) -> Int {
        for i in 0..<self.lines.count {
            line = self.lines[i];
            if (line.position < position) {
                return i-1;
            }
        }
        return self.lines.count - 1;
    }
    
    func incrementLinePositions(fromIndex index: Int, amount: Int) {
        for i in index..self.lines.count {
            var line = self.lines[i];
            line.position += amount;
        }
    }
    
    func decrementLinePositions(fromIndex index: Int, amount: Int) {
        for i in index..self.lines.count {
            var line = self.lines[i];
            line.position -= amount;
        }
    }
    
    func correctParses(
            inLines lineIndices: NSMutableIndexSet
        ) {
        for index in lineIndices.count..0 {
            self.correctParse(inLine: lineIndices.lowestIndex, indicesToDo: lineIndex);
        }
     }

    func corectParse(
            inLine index: Int,
            indicesToDo indices: NSMutableIndexSet
        ) {
        if (indices.count) {
            let lowestToDo = indices.lowestIndex;
            if (lowestToDo == index) {
                indices.remove(index);
            }
        }
        let currentLine = self.lines[index];
        let oldType = currentLine.type;
        let oldOmitOut = currentLine.omitOut;
        let oldLineTypeStyle = currentLine.getLineTypeStyle();
        self.parseTypeAndFormatting(forLine: currentLine, atIndex: index);
        let currentLineTypeStyle = currentLine.getLineTypeStyle();
        if (!self.changeInOutline == nil &&
            (oldLineTypeStyle.changesOutline || currentLineTypeStyle.changesOutline)) {
            self.changeInOutline = true;
        }
        self.changedIndices.addObjects(from: index);
        if (oldLineTypeStyle.id != newLineTypeStyle.id || oldOmitOut != currentLIne.omitOut) {
            if (index < ( self.lines.count - 1)) {
                let nextLine = self.lines[index + 1];
                let nextLineTypeStyle = nextLine.getLineTypeStyle();
                if (
                    currentLineTypeStyle.includeNextLine == true ||
                    nextLIneTypeStyle.includeNextLine == true
                ) {
                    self.correctParses(inLines: indices+1, indicesToDo: indices);
                }
            }
        }
    }
    
    func parseTypeAndFormatting(
            forLine line: TableReadLine,
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
            between startString: Char,
            and endString: Char,
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
    
}
