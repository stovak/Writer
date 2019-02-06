//
//  TableReadFontStyle.swift
//  TableReadWriterMac
//
//  Created by TOM STOVALL on 2/4/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//

import Foundation

struct TableReadFont {
    
    public static let DEFAULT_SIZE = Int16(13);
    
    let id: String;
    let description: String;
    let font: NSFont;
    var size: Int16 = 0;
    
    init(id: String, description: String, font: NSFont) {
        self.id = id;
        self.description = description;
        self.font = font;
        self.getSize();
    }
    
    mutating func getSize() -> Int16 {
        if (self.size == 0) {
            let userDefaults = UserDefaults.init();
            if let fontsize = userDefaults.value(forKey: "Fontsize") as? Int16 {
                self.size = fontsize;
            } else {
                self.size = Int16(TableReadFont.DEFAULT_SIZE);
            }
            
        }
        return self.size;
    }
}

class TableReadFontStyle: NSObject {
    
    public static let courier = TableReadFont.init(
        id: "courier",
        description: "Courier",
        font: NSFont.init(
            descriptor: NSFontDescriptor.init(
                name: "Courier Prime",
                size: CGFloat(TableReadFont.DEFAULT_SIZE)),
            size: CGFloat(TableReadFont.DEFAULT_SIZE) )!
    );
    
    
    public static let boldCourier = TableReadFont.init(
        id: "boldCourier",
        description: "Bold Courier",
        font: NSFont.init(
            descriptor: NSFontDescriptor.init(
                name: "Courier Prime Bold",
                size: CGFloat(TableReadFont.DEFAULT_SIZE)),
            size: CGFloat(TableReadFont.DEFAULT_SIZE) )!
    );
    
    public static let italicCourier = TableReadFont.init(
        id: "italicCourier",
        description: "Italic Courier",
        font: NSFont.init(
            descriptor: NSFontDescriptor.init(
                name: "Courier Prime Italic",
                size: CGFloat(TableReadFont.DEFAULT_SIZE)),
            size: CGFloat(TableReadFont.DEFAULT_SIZE) )!
    );
    
    public static let boldItalicCourier = TableReadFont.init(
        id: "boldItalicCourier",
        description: "Bold Italic Courier",
        font: NSFont.init(
            descriptor: NSFontDescriptor.init(
                name: "Courier Prime Bold Italic",
                size: CGFloat(TableReadFont.DEFAULT_SIZE)),
            size: CGFloat(TableReadFont.DEFAULT_SIZE) )!
    );
    
}
