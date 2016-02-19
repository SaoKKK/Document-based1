//
//  Document.h
//  Document-based1
//
//  Created by 河野 さおり on 2016/02/19.
//  Copyright © 2016年 河野 さおり. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument{
    IBOutlet NSTextView *_textView;
    NSData *dataFromFile;   //読み込みファイルへの参照を保持
}

@end

