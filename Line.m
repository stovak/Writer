//
//  Line.m
//  Writer
//
//  Created by Hendrik Noeller on 01.04.16.
//  Copyright © 2016 Hendrik Noeller. All rights reserved.
//

#import "Line.h"

@implementation Line

- (Line*)initWithString:(NSString*)string position:(NSUInteger)position
{
    self = [super init];
    if (self) {
        _string = string;
        _type = 0;
        _position = position;
    }
    return self;
}

- (NSString *)toString
{
    return [[[[self typeAsString] stringByAppendingString:@": \"" ] stringByAppendingString:self.string] stringByAppendingString:@"\""];
}

- (NSString*)typeAsString
{
    switch (self.type) {
        case empty:
            return @"Empty";
        case section:
            return @"Section";
        case synopse:
            return @"Synopse";
        case titlePageTitle:
            return @"Title Page Title";
        case titlePageAuthor:
            return @"Title Page Author";
        case titlePageCredit:
            return @"Title Page Credit";
        case titlePageSource:
            return @"Title Page Source";
        case titlePageContact:
            return @"Title Page Contact";
        case titlePageDraftDate:
            return @"Title Page Draft Date";
        case titlePageUnknown:
            return @"Title Page Unknown";
        case heading:
            return @"Heading";
        case action:
            return @"Action";
        case character:
            return @"Character";
        case parenthetical:
            return @"Parenthetical";
        case dialogue:
            return @"Dialogue";
        case doubleDialogueCharacter:
            return @"DD Character";
        case doubleDialogueParenthetical:
            return @"DD Parenthetical";
        case doubleDialogue:
            return @"Double Dialogue";
        case transition:
            return @"Transition";
        case lyrics:
            return @"Lyrics";
        case pageBreak:
            return @"Page Break";
        case centered:
            return @"Centered";
    }
}

- (NSString*)typeIdAsString
{
    switch (self.type) {
        case empty:
            return @"empty";
        case section:
            return @"section";
        case synopse:
            return @"synopse";
        case titlePageTitle:
            return @"titlePageTitle";
        case titlePageAuthor:
            return @"titlePageAuthor";
        case titlePageCredit:
            return @"titlePageCredit";
        case titlePageSource:
            return @"titlePageSource";
        case titlePageContact:
            return @"titlePageContact";
        case titlePageDraftDate:
            return @"titlePageDraftDate";
        case titlePageUnknown:
            return @"titlePageUnknown";
        case heading:
            return @"heading";
        case action:
            return @"action";
        case character:
            return @"character";
        case parenthetical:
            return @"parenthetical";
        case dialogue:
            return @"dialogue";
        case doubleDialogueCharacter:
            return @"doubleDialogueCharacter";
        case doubleDialogueParenthetical:
            return @"doubleDialogueParenthetical";
        case doubleDialogue:
            return @"doubleDialogue";
        case transition:
            return @"transition";
        case lyrics:
            return @"lyrics";
        case pageBreak:
            return @"pageBreak";
        case centered:
            return @"centered";
    }
}

@end
