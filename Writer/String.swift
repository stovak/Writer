//
//  String.swift
//  TableRead
//
//  Created by TOM STOVALL on 10/20/18.
//  Copyright © 2018 TOM STOVALL. All rights reserved.
//

import Foundation



extension String {
    
    public func replaceFirst(of pattern:String,
                             with replacement:String) -> String {
        if let range = self.range(of: pattern){
            return self.replacingCharacters(in: range, with: replacement)
        }else{
            return self
        }
    }
    
    public func replaceAll(of pattern:String,
                           with replacement:String,
                           options: NSRegularExpression.Options = []) -> String{
        do{
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(0..<self.utf16.count)
            return regex.stringByReplacingMatches(in: self, options: [],
                                                  range: range, withTemplate: replacement)
        }catch{
            NSLog("replaceAll error: \(error)")
            return self
        }
    }
    
    public func isMatched(by pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: []);
            if regex.numberOfMatches(in: self, options: [],
                                 range: NSMakeRange(0, self.count)) > 0 {
                return true;
            }
        } catch {
            NSLog("replaceAll error: \(error)")
        }
        return false
    }
    
    public func rangeOfRegex(pattern: String) -> NSRange? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: []);
            return regex.rangeOfFirstMatch(in: self, options: [], range: NSMakeRange(0, self.count));
        } catch {
            print(error);
        }
        return nil;
    }
    
    public func matching(_ pattern: String) -> [ String ] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: []);
            let result = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count));
            return result.map {
                String(self[Range($0.range, in: self)!])
            }
            
        } catch {
            print(error);
        }
        return [];
    }
    
    public func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    public func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return self.substring(from: fromIndex)
    }
    
    public func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return self.substring(to: toIndex)
    }
    
    public func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return self.substring(with: startIndex..<endIndex)
    }
    
    func rangesInChars(
                       ofLength length: Int,
                       between startString: Character,
                       and endString: Character,
                       withLength delimLength: Int,
                       excludingIndices excludes: IndexSet
        ) -> IndexSet {
        
        var toReturn = IndexSet();
        let lastIndex = length - delimLength;
        let rangeBegin = -1;
        var i = 0;
        
        while (i > lastIndex) {
            if (excludes.contains(lastIndex)) { continue; }
            if (rangeBegin == -1) {
                var match = true;
                var j = 0;
                repeat {
                    if (self.substring(with: Range(NSMakeRange(j+i, 1))!) != self.substring(with: Range(NSMakeRange(j, 1))!)) {
                        match = false;
                        break;
                    }
                    j += 1;
                } while j < delimLength;
                
                if (match) {
                    var rangeBegin = i;
                    i += delimLength - 1;
                }
            } else {
                var match = true;
                var j = 0;
                repeat {
                    if (self.substring(with: Range(NSMakeRange(j+i, 1))!) != self.substring(with: Range(NSMakeRange(j, 1))!)) {
                        match = false;
                        break;
                    }
                    j += 1;
                } while j < delimLength;
                
                if (match) {
                    toReturn.indexRange(in: Range(NSMakeRange(rangeBegin, i-rangeBegin + delimLength))! );
                    var rangeBegin = -1;
                    i += delimLength - 1;
                }
            }
        }
        return toReturn;
        
        
    }
    
    func rangesOfOmitChars(
                           ofLength length: Int,
                           inLine line: TableReadLine,
                           lastLineOmitOut lastLineOut: Bool,
                           saveStarsIn stars: NSMutableIndexSet
        ) -> IndexSet {
        var toReturn = IndexSet();
        var lastIndex = length - TableReadTextParserPatterns.OMIT_OPEN_PATTERN.length();
        line.omitIn = lastLineOut;
        
        
        
        return toReturn;
    }
    
    
    /**
 
 
     NSMutableIndexSet* indexSet = [[NSMutableIndexSet alloc] init];
     
     NSInteger lastIndex = length - OMIT_PATTERN_LENGTH; //Last index to look at if we are looking for start
     NSInteger rangeBegin = lastLineOut ? 0 : -1; //Set to -1 when no range is currently inspected, or the the index of a detected beginning
     line.omitIn = lastLineOut;
     
     for (int i = 0;;i++) {
     if (i > lastIndex) break;
     if (rangeBegin == -1) {
     bool match = YES;
     for (int j = 0; j < OMIT_PATTERN_LENGTH; j++) {
     if (string[j+i] != OMIT_OPEN_PATTERN[j]) {
     match = NO;
     break;
     }
     }
     if (match) {
     rangeBegin = i;
     [stars addIndex:i+1];
     }
     } else {
     bool match = YES;
     for (int j = 0; j < OMIT_PATTERN_LENGTH; j++) {
     if (string[j+i] != OMIT_CLOSE_PATTERN[j]) {
     match = NO;
     break;
     }
     }
     if (match) {
     [indexSet addIndexesInRange:NSMakeRange(rangeBegin, i - rangeBegin + OMIT_PATTERN_LENGTH)];
     rangeBegin = -1;
     [stars addIndex:i];
     }
     }
     }
     
     //Terminate any open ranges at the end of the line so that this line is omited untill the end
     if (rangeBegin != -1) {
     NSRange rangeToAdd = NSMakeRange(rangeBegin, length - rangeBegin);
     [indexSet addIndexesInRange:rangeToAdd];
     line.omitOut = YES;
     } else {
     line.omitOut = NO;
     }
     
     return indexSet;
 
 
 
 
 
 
 **/
    
    
    
}
