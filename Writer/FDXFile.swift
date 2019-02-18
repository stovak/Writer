//
//  FDXInterface.swift
//  TableReadWriterMac
//
//  Created by TOM STOVALL on 2/18/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Foundation

class FDXFile: NSObject {
    
    let parser: ContinousFountainParser;
    
    var titlePage: [ XMLNode ] = [];
    
    init(fromParser: ContinousFountainParser) {
        self.parser = fromParser;
    }
    
    func toString() -> String {
        let toReturn = XMLDocument(rootElement: self.getRoot());
        return toReturn.xmlString;
    }
    
    func getRoot() -> XMLElement {
        let theRoot = XMLElement(name: "FinalDraft");
        
        theRoot.setAttributesWith([
            "version": "1.0",
            "DocumentType": "Script",
            "Template": "No"
            ]);
        
        theRoot.addChild(self.getContent());
        theRoot.addChild(self.getTitlePage());
        return theRoot;
    }
    
    func getContent() -> XMLElement {
        let content = XMLElement(name: "Content");
        for line in self.parser.lines {
            let toAdd = line.toFDXParagraph();
            if (toAdd.name == "TitlePage") {
                self.titlePage.append(toAdd.child(at: 0)!);
            } else {
                content.addChild(toAdd);
            }
        }
        return content;
    }
    
    func getTitlePage() -> XMLElement {
        let toReturn = XMLElement("TitlePage");
        for element in self.titlePage {
            toReturn.addChild(element);
        }
        return toReturn;
    }
    
    
}
