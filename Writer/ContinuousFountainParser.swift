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
    
    @objc public var lines: [ TableReadLine ] = [];
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
        if (character.first?.isNewline ?? false) {
            var cutOffString = "";
            if (indexInLine == line.string.lengthOfBytes(using: .utf8) ) {
                cutOffString = "";
            } else {
                
                cutOffString = String(line.string[..<line.string.index(line.string.startIndex, offsetBy: indexInLine)]);
                line.string = String(line.string[line.string.index(line.string.startIndex, offsetBy: indexInLine)...]);
            }
            var newline = TableReadLine.init(withString: cutOffString, position: lineIndex + 1);
            self.lines.insert(newline, at: lineIndex + 1);
            self.incrementLinePositions(fromIndex:lineIndex + 2, amount: 1);
            return IndexSet.init(integersIn: Range(NSMakeRange(lineIndex, 2))!);
        } // else
        let pieces = [
            String(line.string[..<line.string.index(line.string.startIndex, offsetBy: indexInLine)]),
            String(character),
            String(line.string[line.string.index(line.string.startIndex, offsetBy: indexInLine)...])
        ];
        line.string = pieces.joined(separator: "");
        self.incrementLinePositions(fromIndex: lineIndex + 1, amount: 1);
        return IndexSet.init(integer: lineIndex);
    }

    func parseCharacterRemoved(atPosition position: Int) -> IndexSet? {
        let lineIndex = self.lineIndex(atPosition: position);
        let line = self.lines[lineIndex];
        let indexInLine = position - line.position;
        if (indexInLine == line.string.count) {
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
            return IndexSet(integer: lineIndex);
        } // else
        let pieces = [
            String(line.string[..<line.string.index(line.string.startIndex, offsetBy: indexInLine)]),
            String(line.string[line.string.index(line.string.startIndex, offsetBy: indexInLine)...])
        ];
        line.string = pieces.joined();
        self.decrementLinePositions(fromIndex: lineIndex + 1, amount: 1);
        return IndexSet(integer: lineIndex);
    
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
        line.type = self.parseLineType(forLine: line, atIndex: index);
        let length = line.string.count;
        
    }
    
    func parseLineType(
            forLine line: TableReadLine,
            atIndex index: Int
        ) -> TableReadLineType {
        let string = line.string.trimmingCharacters(in: CharacterSet.whitespaces);
        let length = string.count;
        if (length == 0) {
            return .empty;
        }
        
        let firstChar = string.first;
        let lastChar = string.last;
        
        //Check for forces (the first character can force a line type)
        if (firstChar == "!") {
            line.numberOfPreceedingFormattingCharacters = 1;
            return .action;
        }
        if (firstChar == "@") {
            line.numberOfPreceedingFormattingCharacters = 1;
            return .character;
        }
        if (firstChar == "~") {
            line.numberOfPreceedingFormattingCharacters = 1;
            return .lyrics;
        }
        if (firstChar == ">" && lastChar != "<") {
            line.numberOfPreceedingFormattingCharacters = 1;
            return .transition;
        }
        if (firstChar == "#") {
            line.numberOfPreceedingFormattingCharacters = 1;
            return .section;
        }
        if (firstChar == "=" && (length >= 2 ? string.first != "=" : true)) {
            line.numberOfPreceedingFormattingCharacters = 1;
            return .synopse;
        }
        if (firstChar == "." && length >= 2 && string.first != ".") {
            line.numberOfPreceedingFormattingCharacters = 1;
            return .heading;
        }
        
        let preceedingLine = (index == 0) ? nil : self.lines[index - 1];
        let firstColonInRange = string.range(of: ":");
        let preceedingLineIsNil = ( preceedingLine == nil );
        let preceedingLineIsMetaData = ( preceedingLine?.getLineTypeStyle().isMetaData ?? false );

        
        if ( (preceedingLineIsNil || preceedingLineIsMetaData) && firstColonInRange != nil ) {
            let upToFirstColon = String(string[..<firstColonInRange!.upperBound].localizedCapitalized);
            let lineTypeStyles = TableReadLineTypeStyles();
            if let lineTypeStyle = (lineTypeStyles.value(forKey: "titlePage" + upToFirstColon) as? TableReadLineTypeStyle) {
                return lineTypeStyle.lineType;
            }
            return TableReadLineType.titlePageUnknown;
        }
        if (preceedingLine != nil){
            if (length >= 2 && string.substring(to: 2) == "  ") {
                line.numberOfPreceedingFormattingCharacters = 2;
                return preceedingLine!.type;
            } else if (length >= 1 && string.substring(to: 1) == "\t") {
                line.numberOfPreceedingFormattingCharacters = 1;
                return preceedingLine!.type;
            }
        }
        
        let firstThreeLetters = string.substring(to: 3).lowercased();
        let lastThreeLetters = string.substring(from: 3).lowercased();

        if (preceedingLine?.type == .empty) {
            if (length >= 3) {
                if (
                    firstThreeLetters == "int" ||
                    firstThreeLetters == "ext" ||
                    firstThreeLetters == "est" ||
                    firstThreeLetters == "i/e"
                    ) {
                    return .heading;
                }
                if ( lastThreeLetters == "to:") {
                    return .transition;
                }
                if ( firstThreeLetters == "===") {
                    return .pageBreak;
                }
            }
            if (firstChar == ">" && lastChar == "<") {
                return .centered;
            }
        }
        if (preceedingLine != nil) {
            if (
                preceedingLine!.type == .character ||
                preceedingLine!.type == .dialogue  ||
                preceedingLine!.type == .parenthetical
                ) {
                if (firstChar == "(" && lastChar == ")") {
                    return .parenthetical
                }
                return .dialogue
            } else if (
                preceedingLine!.type == .doubleDialogueCharacter ||
                preceedingLine!.type == .doubleDialogue ||
                preceedingLine!.type == .doubleDialogueParenthetical
            ) {
                //Text in parentheses after character or dialogue is a parenthetical, else its dialogue
                if (firstChar == "(" && lastChar == ")") {
                    return .doubleDialogueParenthetical;
                } else {
                    return .doubleDialogue;
                }
            } else if (preceedingLine!.type == .section) {
                return .section;
            } else if (preceedingLine!.type == .synopse) {
                return .synopse;
            }
        }
        
        return .action
    }
    
    
    
    func sceneNumber(
            forChars string: String,
            ofLength length: Int
        ) -> NSRange {
        
        var backNumberIndex = NSNotFound;
        var i = length - 1;
        
        repeat {
            var c = string.substring(with: Range(NSMakeRange(i, 1))!);
            if (c == " ") { continue; }
            if (backNumberIndex == NSNotFound) {
                if (c == "#") {
                    backNumberIndex = i;
                }
                else {
                    break;
                }
            } else {
                if (c == "#") {
                    return NSMakeRange(i+1, backNumberIndex-i-1);
                }
            }
            i -= 1;
        } while i >= 0;
        return NSMakeRange(0, 0);
    }
    
    func string(atLine lineNum: Int) -> String {
        if (lineNum >= self.lines.count) {
            return "";
        } else {
            return self.lines[lineNum].string;
        }
    }
    
    func type(atLine lineNum: Int) -> TableReadLineType {
        if (lineNum >= self.lines.count) {
            return .empty;
        } else {
            return self.lines[lineNum].type;
        }
    }
    
    func position(atLine lineNum: Int) -> Int {
        if (lineNum >= self.lines.count) {
            return NSNotFound;
        } else {
            return self.lines[lineNum].position;
        }
    }
    
    func sceneNumber(atLine lineNum: Int) -> Int? {
        if (lineNum >= self.lines.count) {
            return nil;
        } else {
            return self.lines[lineNum].sceneNumber;
        }
    }
    
    func numberOfOutlineItems() -> Int {
        var result = 0;
        for eachLine in self.lines {
            if (eachLine.type == .section || eachLine.type == .synopse || eachLine.type == .heading) {
                result += 1;
            }
        }
        return result;
    }
    
    func outlineItem(atIndex index: Int) -> TableReadLine? {
        var toReturn = index;
        for eachLine in self.lines {
            if (eachLine.type == .section || eachLine.type == .synopse || eachLine.type == .heading) {
                if (index == 0) {
                    return eachLine;
                }
                toReturn -= 1;
            }
        }
        return nil;
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
