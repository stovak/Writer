//
//  OutlineExtractor.h
//  Writer
//
//  Created by Hendrik Noeller on 11.05.16.
//  Copyright © 2016 Hendrik Noeller. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TableReadWriterMac-Swift.h"

@class ContinousFountainParser;

@class TableReadLine;

@interface OutlineExtractor : NSObject

+ (NSString*)outlineFromParse:(ContinousFountainParser*)parser;

@end
