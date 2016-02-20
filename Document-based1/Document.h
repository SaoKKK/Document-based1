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
    NSString *strFromFile;   //読み込みテキストを保持
}

@end

