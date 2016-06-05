//
//  Document.m
//  Document-based1
//
//  Created by 河野 さおり on 2016/02/19.
//  Copyright © 2016年 河野 さおり. All rights reserved.
//

#import "Document.h"

@interface Document ()

@end

@implementation Document{
    IBOutlet NSTextField *txtNewTxt;
    IBOutlet NSScrollView *scrView;
    IBOutlet NSWindow *window;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    if (strFromFile) {
        [self setValueToTextView:strFromFile];
        strFromFile = nil;
    }
}

+ (BOOL)autosavesInPlace {
    //オートセーブのON/OFF
    return NO;
}

- (NSString *)windowNibName {
    return @"Document";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    //サポートするタイプのドキュメントデータをNSDataオブジェクトにパッケージして返す
    //テキストビューのテキストをデータとして返す
    NSData *data = [[_textView string]dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    //ドキュメントデータを読み込みドキュメントウインドウに表示
    //ファイルからテキストを読み込み
    NSString *txt = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (! txt) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
        return NO;
    } else {
        if (_textView) {
            //復帰のための読み込みの場合（既存のテキストビューに直接読み込む）
            [self setValueToTextView:txt];
        } else {
            //ファイルを開く場合
            strFromFile = txt;
        }
        return YES;
    }
}

//テキストビューにテキストをセット
- (void)setValueToTextView:(NSString*)txt{
    [_textView replaceCharactersInRange:NSMakeRange(0, [[_textView string]length]) withString:txt];
}

//更新フラグを立てる
- (IBAction)updateChangeInfoToDocument:(id)sender{
    [self updateChangeCount:NSChangeDone];
}

- (NSPrintOperation*)printOperationWithSettings:(NSDictionary<NSString *,id> *)printSettings error:(NSError * _Nullable __autoreleasing *)outError{
    NSString *docTitle = [self.windowControllers objectAtIndex:0].window.title;
    NSPrintOperation *op = [NSPrintOperation printOperationWithView:_textView printInfo:self.printInfo];
    [op setJobTitle:docTitle];
    return op;
}

- (NSPrintInfo*)printInfo{
    NSPrintInfo *printInfo = [super printInfo];
    [printInfo setHorizontallyCentered:NO];
    [printInfo setVerticallyCentered:NO];
    [printInfo setLeftMargin:72.0];
    [printInfo setRightMargin:72.0];
    [printInfo setTopMargin:72.0];
    [printInfo setBottomMargin:72.0];
    return printInfo;
}

- (IBAction)pshChangeTxt1:(id)sender {
    NSUndoManager *_undoMgr = self.undoManager;
    [[_undoMgr prepareWithInvocationTarget:self] undoChangeTxt:_textView.string.copy];
    [_undoMgr setActionName:NSLocalizedString(@"TxtChange", @"")];
    [[sender window] makeFirstResponder:_textView];
    [_textView setString:txtNewTxt.stringValue];
}

- (void)undoChangeTxt:(NSString*)oldTxt{
    NSUndoManager *_undoMgr = self.undoManager;
    [[_undoMgr prepareWithInvocationTarget:self] undoChangeTxt:_textView.string.copy];
    [_undoMgr setActionName:NSLocalizedString(@"TxtChange", @"")];
    [_textView setString:oldTxt];
}

- (IBAction)pshChangeTxt2:(id)sender {
    [self changeTxt:txtNewTxt.stringValue];
}

- (void)changeTxt:(NSString*)aTxt{
    NSUndoManager *_undoMgr = self.undoManager;
    [_undoMgr registerUndoWithTarget:self selector:@selector(changeTxt:) object:_textView.string.copy];
    [_undoMgr setActionName:NSLocalizedString(@"TxtChange", @"")];
    [_textView.window makeFirstResponder:_textView];
    [_textView setString:aTxt];
}

@end