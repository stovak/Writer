//
//  HTML5Extractor.swift
//  TableReadWriterMac
//
//  Created by TOM STOVALL on 2/18/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Foundation

class HTML5Extractor: FDXExtractor {
    
    override func getRoot() -> XMLElement {
        let theRoot = XMLElement(name: "HTML");
        theRoot.addChild(self.getHead());
        theRoot.addChild(self.getBody());
        return theRoot;
    }
    
    func getHead() -> XMLElement {
        let toReturn = XMLElement(name: "HEAD");
        // TODO: Add css that makes this work
        return toReturn;
    }
    
    func getBody() -> XMLElement {
        let toReturn = XMLElement(name: "BODY");
        for line in self.parser.lines {
            toReturn.addChild(line.toHTMLElement());
        }
        return toReturn;
    }
    
}
