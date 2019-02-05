//
//  DocumentWindow.swift
//  TableReadWriterMac
//
//  Created by TOM STOVALL on 2/2/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//


import Foundation
import AppKit
import WebKit

@objc
class DocumentWindow: NSDocument, NSTextViewDelegate, NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    public static let MATCH_PARENTHESES_KEY = "Match Parentheses";
    public static let LIVE_PREVIEW_KEY = "Live Preview";
    public static let FONTSIZE_KEY = "Fontsize";
    public static let DEFAULT_FONTSIZE = 13;
    public static let TEXT_INSET_SIDE = 50;
    public static let TEXT_INSET_TOP = 20;
    public static let INITIAL_WIDTH = 800;
    
    
    @IBOutlet unowned var toolbar: NSToolbar?;
    @IBOutlet unowned var textView: NSTextView?;
    @IBOutlet weak var outlineView: NSOutlineView?;
    @IBOutlet unowned var webView: WebView?;
    @IBOutlet unowned var tabView: NSTableView?;
    @IBOutlet weak var backgroundView: ColorView?;
    @IBOutlet weak var oulineViewWidth: NSLayoutConstraint?;
    var outlineViewVisible: Bool;
    
    
    @IBOutlet weak var outlineToolbarButton: NSButton?;
    @IBOutlet weak var boldToolbarButton: NSButton?;
    @IBOutlet weak var italicToolbarButton: NSButton?;
    @IBOutlet weak var underlineToolbarButton: NSButton?;
    @IBOutlet weak var omitToolbarButton: NSButton?;
    @IBOutlet weak var noteToolbarButton: NSButton?;
    @IBOutlet weak var forceHeadingToolbarButton: NSButton?;
    @IBOutlet weak var forceActionToolbarButton: NSButton?;
    @IBOutlet weak var forceCharacterToolbarButton: NSButton?;
    @IBOutlet weak var forceTransitionToolbarButton: NSButton?;
    @IBOutlet weak var forceLyricsToolbarButton: NSButton?;
    @IBOutlet weak var titlepageToolbarButton: NSButton?;
    @IBOutlet weak var pagebreakToolbarButton: NSButton?;
    @IBOutlet weak var previewToolbarButton: NSButton?;
    @IBOutlet weak var printToolbarButton: NSButton?;
    
    var toolbarButtons: [ NSButton? ];
    var contentBuffer: String;
    
    var courier: NSFont;
    var boldCourier: NSFont;
    var italicCourier: NSFont;
    var boldItalicCourier: NSFont;
    
    var fontsize: NSInteger;
    var livePreview: Bool;
    var matchParentheses: Bool;
    
    var printView: PrintView;
    
    var parser: ContinousFountainParser;
    
    var themeManager: ThemeManager;
    
    override init() {
        super.init();
        self.printInfo.topMargin = 25;
        self.printInfo.bottomMargin = 50;
    }
    
    override func windowControllerDidLoadNib(_ windowController: NSWindowController) {
        super.windowControllerDidLoadNib(windowController);
        
        var window = windowController.window;
        var newFrame = NSMakeRect(
            (window?.frame.origin.x)!,
            (window?.frame.origin.y)!,
            (window?.frame.size.width)!,
            (window?.frame.size.height)!
        );
        window?.setFrame(newFrame, display: true);
        
        
        self.outlineViewVisible = false;
        self.outlineView?.widthAnchor.constraint(equalToConstant: 0);
        
        self.toolbarButtons = [
            self.outlineToolbarButton,
            self.boldToolbarButton,
            self.italicToolbarButton,
            self.underlineToolbarButton,
            self.omitToolbarButton,
            self.noteToolbarButton,
            self.forceHeadingToolbarButton,
            self.forceActionToolbarButton,
            self.forceCharacterToolbarButton,
            self.forceTransitionToolbarButton,
            self.forceLyricsToolbarButton,
            self.titlepageToolbarButton,
            self.pagebreakToolbarButton,
            self.previewToolbarButton,
            self.printToolbarButton
        ];
        
        self.textView!.textContainerInset = NSMakeSize(
            CGFloat(DocumentWindow.TEXT_INSET_SIDE),
            CGFloat(DocumentWindow.TEXT_INSET_TOP)
        );
        
        self.backgroundView?.fillColor = NSColor(calibratedRed: CGFloat(0.5), green: CGFloat(0.5), blue: CGFloat(0.5), alpha: CGFloat(1.0));
        self.textView?.setFont(
            self.courier,
            range: NSRange(location: 0, length: (self.textView?.string.lengthOfBytes(using: String.Encoding.utf8))!)
        );
        self.textView?.isAutomaticQuoteSubstitutionEnabled = false;
        self.textView?.isAutomaticDataDetectionEnabled = false;
        self.textView?.isAutomaticDashSubstitutionEnabled = false;
        
        var userDefaults = UserDefaults.init();
        self.matchParentheses = userDefaults.value(forKey: "MATCH_PARENTHESES_KEY") as! Bool;
        if (self.contentBuffer != nil) {
            self.setText(self.contentBuffer);
        } else {
            self.setText("");
        }
        
        //Initialize Theme Manager (before the formatting, because we need the colors for formatting!)
        self.themeManager = ThemeManager.shared();
        
        
        self.parser = ContinousFountainParser.init(string: self.getText());
        self.applyFormatChanges();
    }
    
    func autosavesInPlace() -> Bool {
        return true;
    }
    
    func windowNibName() -> String {
        return "Document";
    }
    
    override func data(ofType typeName: String) throws -> Data {
        let dataRepresentation = self.getText().data(using: .utf8);
        return dataRepresentation!;
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        self.setText(String(data: data, encoding: .utf8)!);
    }
    
    func getText() -> String {
        return self.textView?.string ?? "";
    }
    
    func setText(_ text: String) {
        if (self.textView == nil) {
            self.contentBuffer = text;
        } else {
            self.textView?.string = text;
        }
    }
    
    func selectedTabViewTab() -> Int {
        // objC return [self.tabView indexOfTabViewItem:[self.tabView selectedTabViewItem]];
        return 0
    }
    
    
    
    @IBAction func printDocumentStandard(_ sender: Any) {
        if (self.getText().lengthOfBytes(using: String.Encoding.utf8) == 0) {
            let alert = NSAlert();
            alert.messageText = "Can not print an empty document";
            alert.informativeText = "Please enter some text before printing, or obtain white paper directly by accessing you printers paper tray.";
            alert.alertStyle = NSAlert.Style.warning;
            alert.beginSheetModal(for: self.windowControllers[0].window!, completionHandler: nil);
        } else {
            self.printView = PrintView.init(document: self, toPDF: false);
        }
    }
    
    @IBAction func exportPDF(_ sender: Any) {
        self.printView = PrintView.init(document: self, toPDF: true);
    }
    
    @IBAction func exportHMTL(_ sender: Any) throws {
        let saveDialog = NSSavePanel();
        saveDialog.allowedFileTypes = [ "html" ];
        saveDialog.representedFilename = self.lastComponentOfFileName;
        saveDialog.nameFieldStringValue = self.lastComponentOfFileName;
        saveDialog.begin {
            (result) -> Void in
            if (result.rawValue == NSApplication.ModalResponse.OK.rawValue) {
                let fnScript = FNScript.init(string: self.getText());
                let htmlScript = FNHTMLScript.init(script: fnScript);
                let htmlString = htmlScript?.html();
                do {
                    try htmlString?.write(to: saveDialog.url!, atomically: true, encoding: String.Encoding.utf8);
                } catch {
                    ErrorHandler(error);
                }
            }
        }
    }
    
    
    
    @IBAction func exportFDX(_ sender: Any) {
        let saveDialog = NSSavePanel();
        saveDialog.allowedFileTypes = [ "html" ];
        saveDialog.representedFilename = self.lastComponentOfFileName;
        saveDialog.nameFieldStringValue = self.lastComponentOfFileName;
        saveDialog.begin {
            (result) -> Void in
            if (result.rawValue == NSApplication.ModalResponse.OK.rawValue) {
                let fdxString = FDXInterface.fdx(from: self.getText());
                
                do {
                    try fdxString?.write(to: saveDialog.url!, atomically: true, encoding: String.Encoding.utf8);
                } catch {
                    ErrorHandler(error);
                }
            }
        }
    }
    
    @IBAction func exportOutline(_ sender: Any) {
        let saveDialog = NSSavePanel();
        saveDialog.allowedFileTypes = [ "html" ];
        saveDialog.representedFilename = self.lastComponentOfFileName;
        saveDialog.nameFieldStringValue = self.lastComponentOfFileName;
        saveDialog.begin {
            (result) -> Void in
            if (result.rawValue == NSApplication.ModalResponse.OK.rawValue) {
                let outlineString = OutlineExtractor.outline(fromParse: self.parser);
                do {
                    try outlineString?.write(to: saveDialog.url!, atomically: true, encoding: String.Encoding.utf8);
                } catch {
                    ErrorHandler(error);
                }
            }
        }
    }
    
    func fileNameString() -> String {
        let fileName = self.lastComponentOfFileName;
        guard let lastDotIndex = fileName.range(of: ".")
            else { return fileName };
        
        return fileName;
    }
    
    func updateWebView() {
        let script = FNScript.init(string: self.getText());
        let htmpScript = FNHTMLScript.init(script: script!);
        self.webView?.mainFrame.loadHTMLString(htmpScript!.html(), baseURL: nil);
    }
    
    func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        if (self.matchParentheses) {
            if (affectedCharRange.length == 0) {
                if (replacementString?.compare("(")) {
                    
                }
            }
        }
    }
    
    func replaceCharacterInRange(range: NSRange, withString: String) {
        if (self.textView?.shouldChangeText(in: range, replacementString: withString) ?? false) {
            self.textView?.replaceCharacters(in: range, with: withString);
            self.textDidChange(NSNotification(name: "", object: nil));
        }
    }
 
    func textDidChange(_ notification: Notification) {
        
    }
    
    func addString(string: String, atIndex: Int) {
        self.replaceCharacterInRange(range: NSMakeRange(atIndex, 0), withString: string);
        let undo = self.undoManager?.prepare(withInvocationTarget: self) as! DocumentWindow;
        // [[[self undoManager] prepareWithInvocationTarget:self] removeString:string atIndex:index];
        undo.removeString(string: string, atIndex: atIndex);
    }
    
    func removeString(string: String, atIndex: Int) {
        self.replaceCharacterInRange(range: NSMakeRange(atIndex, string.lengthOfBytes(using: String.Encoding.utf8)), withString: string);
        let undo = self.undoManager?.prepare(withInvocationTarget: self) as! DocumentWindow;
        undo.addString(string: string, atIndex: atIndex);
    }
    
    func makeBold(sender: Any) {
        if (self.selectedTabViewTab() == 0) {
            // [self format:cursorLocation beginningSymbol:boldSymbol endSymbol:boldSymbol];
        }
    }

    func makeItalic(sender: Any) {
        if (self.selectedTabViewTab() == 0) {
            // [self format:cursorLocation beginningSymbol:italicSymbol endSymbol:italicSymbol];
        }
    }
    
    func makeUnderlined(sender: Any) {
        if (self.selectedTabViewTab() == 0) {
            // [self format:cursorLocation beginningSymbol:underlinedSymbol endSymbol:underlinedSymbol];
        }
    }
    
    func makeNote(sender: Any) {
        if (self.selectedTabViewTab() == 0) {
            // [self format:cursorLocation beginningSymbol:noteOpen endSymbol:noteClose];
        }
    }
    
    func makeOmitted(sender: Any) {
        if (self.selectedTabViewTab() == 0) {
            // [self format:cursorLocation beginningSymbol:omitOpen endSymbol:omitClose];
        }
    }
    
    func cursorLocation() -> NSRange {
        return self.textView?.selectedRanges[0].rangeValue ?? NSRange(location: 0, length: 0);
    }
    
    func textView(_ textView: NSTextView, shouldChangeTextInRanges affectedRanges: [ NSValue ], replacementStrings: [String]?) -> Bool {
        var count = 0;
        if (self.matchParentheses) {
            for range in affectedRanges {
                if (range.rangeValue.length ==  0) {
                    if (replacementStrings[count].isEqualTo("(")) {
                        self.addString(string: ")", atIndex: range.rangeValue.location);
                    }
                    count = count + 1;
                }
            }
        }
        
        /**
 
         if (self.matchParentheses) {
         if (affectedCharRange.length == 0) {
         if ([replacementString isEqualToString:@"("]) {
         [self addString:@")" atIndex:affectedCharRange.location];
         [self.textView setSelectedRange:affectedCharRange];
         
         } else if ([replacementString isEqualToString:@"["]) {
         if (affectedCharRange.location != 0) {
         unichar characterBefore = [[self.textView string] characterAtIndex:affectedCharRange.location-1];
         
         if (characterBefore == '[') {
         [self addString:@"]]" atIndex:affectedCharRange.location];
         [self.textView setSelectedRange:affectedCharRange];
         }
         }
         } else if ([replacementString isEqualToString:@"*"]) {
         if (affectedCharRange.location != 0) {
         unichar characterBefore = [[self.textView string] characterAtIndex:affectedCharRange.location-1];
         
         if (characterBefore == '/') {
         [self addString: atIndex:affectedCharRange.location];
        [self.textView setSelectedRange:affectedCharRange];
            }
        }
        }
        }
        }
        [self.parser parseChangeInRange:affectedCharRange withString:replacementString];
         **/
    }

    func textDidChange(notification: NSNotification) {
        if (self.outlineViewVisible && self.parser.getAndResetChangeInOutline()) {
            self.outlineView?.reloadData();
        }
        self.applyFormatChanges();
    }
    
    func formatAllLines() {
        if (self.livePreview) {
            for line in self.parser.lines {
                self.formatLineOfScreenplay(line as! Line, onlyFormatFont: false);
            }
        } else {
            self.textView?.font = self.courier;
            self.textView?.textColor = self.themeManager.currentTextColor();
            
            if (self.textView?.textStorage != nil) {
                let paragraphStyle = TableReadParagraphStyle();
                paragraphStyle.applyTo(textStorage: self.textView!.textStorage!);
            }
            
        }
    }
    
    func formatLineOfScreenplay(_ line: Line, onlyFormatFont: Bool = false ) {
        let begin = Int(line.position);
        let length = line.string.lengthOfBytes(using: String.Encoding.utf8);
        let range = NSMakeRange(begin, length);
        let lineType = TableReadLineTypes.value(forKey: line.typeIdAsString()) as! TableReadLineType;
        self.textView?.textStorage?.removeAttribute(NSAttributedString.Key.font, range: range);
        self.textView?.textStorage?.addAttribute(NSAttributedString.Key.font, value: TableReadLineTypes.getFontStyle(forFontStyleID: lineType.fontStyle), range: range);
        if (!onlyFormatFont) {
            self.textView?.textStorage?.removeAttribute(NSAttributedString.Key.paragraphStyle, range: range);
            self.textView?.textStorage?.addAttribute(NSAttributedString.Key.paragraphStyle, value: TableReadLineTypes.getParagraphStyle(forTypeID: lineType.id), range: range);
        }
        // do bold and italic changes
        // do uppercase where lineType.uppercase == true
    }
    
    func refontAllLines() {
        for line in self.parser.lines {
            self.formatLineOfScreenplay(line as! Line, onlyFormatFont: true);
        }
    }
    
    func applyFormatChanges() {
        for case let index as Int in self.parser.changedIndices {
            let line = self.parser.lines?[index] as! Line;
            self.formatLineOfScreenplay(line, onlyFormatFont: false);
        }
        self.parser.changedIndices.removeAllObjects();
    }
    
   
}
