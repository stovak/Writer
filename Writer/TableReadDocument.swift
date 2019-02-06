//
//  DocumentWindow.swift
//  TableReadWriterMac
//
//  Created by TOM STOVALL on 2/2/19.
//  Copyright © 2019 Hendrik Noeller. All rights reserved.
//


import Cocoa
import AppKit
import WebKit

@objc
class TableReadDocument: NSDocument, NSTextViewDelegate, NSOutlineViewDataSource, NSOutlineViewDelegate {
    
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
    
    var outlineViewVisible: Bool = false;

    var toolbarButtons: [ NSButton? ] = [];
    var contentBuffer: String = "";
    
    var livePreview: Bool = false;
    var matchParentheses: Bool = true;
    
    var printView: PrintView?;
    
    var parser: ContinousFountainParser?;
    
    var themeManager: ThemeManager?;
    
    override init() {
        debugPrint("TableReadDocument.init");
        super.init();
        self.printInfo.topMargin = 25;
        self.printInfo.bottomMargin = 50;
    }
    
    override func windowControllerDidLoadNib(_ windowController: NSWindowController) {
        debugPrint("windowControllerDidLoadNib");
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
            CGFloat(TableReadDocument.TEXT_INSET_SIDE),
            CGFloat(TableReadDocument.TEXT_INSET_TOP)
        );
        
        self.backgroundView?.fillColor = NSColor(calibratedRed: CGFloat(0.5), green: CGFloat(0.5), blue: CGFloat(0.5), alpha: CGFloat(1.0));
        self.textView?.setFont(
            TableReadFontStyle.courier.font,
            range: NSRange(location: 0, length: (self.textView?.string.lengthOfBytes(using: String.Encoding.utf8))!)
        );
        self.textView?.isAutomaticQuoteSubstitutionEnabled = false;
        self.textView?.isAutomaticDataDetectionEnabled = false;
        self.textView?.isAutomaticDashSubstitutionEnabled = false;
        
        let userDefaults = UserDefaults.init();
        if let matchParen = userDefaults.value(forKey: "MATCH_PARENTHESES_KEY") as? Bool {
            self.matchParentheses = matchParen;
        } else {
            self.matchParentheses = false;
        }
        
        if (self.contentBuffer != nil) {
            self.setText(self.contentBuffer);
        } else {
            self.setText("");
        }
        //Initialize Theme Manager (before the formatting, because we need the colors for formatting!)
        
        self.getParser();

        self.applyFormatChanges();
    }
    
    func getParser() -> ContinousFountainParser {
        self.getThemeManager();
        if (self.parser == nil) {
            self.parser = ContinousFountainParser.init(string: self.getText());
        }
        return self.parser!;
    }
    
    func getThemeManager() -> ThemeManager {
        if (self.themeManager == nil) {
            self.themeManager = ThemeManager.shared();
        }
        return self.themeManager!;
    }
    
    
    override class var autosavesInPlace: Bool {
        return true
    }
    
    func windowNibName() -> NSNib.Name? {
        debugPrint("windowNibName");
        return NSNib.Name("TableReadDocument");
    }
    
    override func data(ofType typeName: String) throws -> Data {
        debugPrint("Data OfType: \(typeName)");
        let dataRepresentation = self.getText().data(using: .utf8);
        return dataRepresentation!;
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        debugPrint("read Data \(typeName)");
        debugPrint(data);
        self.setText(String(data: data, encoding: .utf8)!);
        debugPrint(self.getText());
    }
    
    override func read(from url: URL, ofType typeName: String) throws {
        debugPrint("read URL: \(typeName)");
        debugPrint(url);
        do {
            let text = try String(contentsOf: url);
            debugPrint(text);
            self.setText(text);
            
        } catch {
            ErrorHandler(error);
        }
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
                let outlineString = OutlineExtractor.outline(fromParse: self.getParser());
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
        if (self.matchParentheses && replacementString != nil) {
            if (affectedCharRange.length == 0) {
                if (replacementString! == "(") {
                    return true;
                }
            }
        }
        return false;
    }
    
    func replaceCharacterInRange(range: NSRange, withString: String) {
        if (self.textView?.shouldChangeText(in: range, replacementString: withString) ?? false) {
            self.textView?.replaceCharacters(in: range, with: withString);
            self.textDidChange(NSNotification(name: NSNotification.Name.init(rawValue: "Now is the time"), object: self) as Notification);
        }
    }
 
    func textDidChange(_ notification: Notification) {
        
    }
    
    func addString(string: String, atIndex: Int) {
        self.replaceCharacterInRange(range: NSMakeRange(atIndex, 0), withString: string);
        let undo = self.undoManager?.prepare(withInvocationTarget: self) as! TableReadDocument;
        // [[[self undoManager] prepareWithInvocationTarget:self] removeString:string atIndex:index];
        undo.removeString(string: string, atIndex: atIndex);
    }
    
    func removeString(string: String, atIndex: Int) {
        self.replaceCharacterInRange(range: NSMakeRange(atIndex, string.lengthOfBytes(using: String.Encoding.utf8)), withString: string);
        let undo = self.undoManager?.prepare(withInvocationTarget: self) as! TableReadDocument;
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
        if (self.matchParentheses && replacementStrings != nil) {
            for range in affectedRanges {
                if (range.rangeValue.length ==  0) {
                    if (replacementStrings![count] == "(") {
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
        return true;
    }

    func textDidChange(notification: NSNotification) {
        if (self.outlineViewVisible && self.getParser().getAndResetChangeInOutline()) {
            self.outlineView?.reloadData();
        }
        self.applyFormatChanges();
    }
    
    func formatAllLines() {
        if (self.livePreview) {
            for line in self.getParser().lines {
                self.formatLineOfScreenplay(line as! Line, onlyFormatFont: false);
            }
        } else {
            self.textView?.font = TableReadFontStyle.courier.font;
            self.textView?.textColor = self.getThemeManager().currentTextColor();
            
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
        for line in self.getParser().lines {
            self.formatLineOfScreenplay(line as! Line, onlyFormatFont: true);
        }
    }
    
    func applyFormatChanges() {
        for case let index as Int in self.getParser().changedIndices {
            let line = self.getParser().lines?[index] as! Line;
            self.formatLineOfScreenplay(line, onlyFormatFont: false);
        }
        self.getParser().changedIndices.removeAllObjects();
    }
    
    override func makeWindowControllers() {
        let controller = NSWindowController(windowNibName: "TableReadDocument", owner: self);
        self.addWindowController(controller);
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if (item != nil) {
            return self.parser?.numberOfOutlineItems() as! Int;
        }
        return 0;
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if (item != nil) {
            return self.parser?.outlineItem(at: UInt(bitPattern: index));
        }
        return 0;
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false;
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        if let line = item as? Line {
            switch(line.typeIdAsString()) {
                
                
            case "heading":
                //Replace "INT/EXT" with "I/E" to make the lines match nicely
                var string = line.string.uppercased();
                string = string.replacingOccurrences(of: "INT/EXT", with: "I/E");
                string = string.replacingOccurrences(of: "INT./EXT", with: "I/E");
                string = string.replacingOccurrences(of: "EXT/INT", with: "I/E");
                string = string.replacingOccurrences(of: "EXT./INT", with: "I/E");
                
                
                if ((line.sceneNumber) != nil) {
                    return String(format: "    %@: %@", line.sceneNumber, string.replacingOccurrences(of: String(format: "#%@#", line.sceneNumber), with: ""));
                } else {
                    return NSString(utf8String: "    ".appending(string));
                }
                break;
                
                
            case "synopse":
                var text = line.string;
                
                if (text != nil && (!text!.isEmpty)) {
                    //Remove "="
                    let startIndex = text!.index(text!.startIndex, offsetBy: 1);
                    let firstLetter = String(text![..<startIndex]);
                    if ( firstLetter == "=") {
                        text = text!.replacingCharacters(in:  ..<startIndex, with: "");
                    }
                    //Remove leading whitespace
                    text = text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines);
                    
                    return "  ".appending(text!);
                } else {
                    return line.string;
                }
                
                break;
                
                
            case "section":
                var text = line.string;
                if (text != nil && (!text!.isEmpty)) {
                    let startIndex = text!.index(text!.startIndex, offsetBy: 1);
                    let firstLetter = String(text![..<startIndex]);
                    if (firstLetter == "#") {
                        text = text!.replacingCharacters(in: ..<startIndex, with: "");
                    }
                    text = text!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines);
                    return text;
                } else {
                    return line.string;
                }
                break;
                
            default:
                return line.string;
            }
            
        }
        return "";
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        if let line = item as? Line {
            let lineRange = NSMakeRange(Int(line.position), Int(line.string.lengthOfBytes(using: String.Encoding.utf8) ));
            self.textView?.setSelectedRange(lineRange);
            self.textView?.scrollRangeToVisible(lineRange);
            return true;
        }
        return false;
    }
    
   
}
