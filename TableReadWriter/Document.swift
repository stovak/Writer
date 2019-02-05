//
//  Document.swift
//  TableReadWriter
//
//  Created by TOM STOVALL on 2/1/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import UIKit

class Document: UIDocument {
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        return Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
    }
}

