//
//  OutlineExtractor.swift
//  TableReadWriterMac
//
//  Created by TOM STOVALL on 2/17/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Foundation


class OutlineExtractor: NSObject {
    
    func outline(_ parser: ContinousFountainParser) -> String {
        var result = String();
        var lastLine: TableReadLine? = nil;
        for line in parser.lines {
            if (line.type == TableReadLineType.section || line.type == TableReadLineType.synopse || line.type == TableReadLineType.heading) {
                if (lastLine != nil && (line.type == TableReadLineType.heading || lastLine?.type == line.type)) {
                    result += "\n";
                }
                lastLine = line;
                result += line.string + "\n";
            }
        }
        
        return result;
    }
    
}
