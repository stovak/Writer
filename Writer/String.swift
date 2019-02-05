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
    
}
