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

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    if (dataFromFile) {
        [self loadtextViewWithData:dataFromFile];
        dataFromFile = nil;
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
    if (_textView) {
        //復帰のための読み込みの場合（既存のテキストビューに直接読み込む）
        [self loadtextViewWithData:data];
    } else {
        //ファイルを開く場合
        dataFromFile = data;
    }
    return YES;
}

//ファイルからテキストビューにデータを読み込む
- (void)loadtextViewWithData:(NSData *)data{
    NSString *txt = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [_textView replaceCharactersInRange:NSMakeRange(0, [[_textView string]length]) withString:txt];
}

@end
