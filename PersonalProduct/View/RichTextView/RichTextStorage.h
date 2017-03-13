//
//  RichTextStorage.h
//  TextKitForView
//
//  Created by ios_zhu on 2017/1/3.
//  Copyright © 2017年 ios_zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RichTextStorage : NSTextStorage

@property (nonatomic, readonly) NSString *richText;

@property (nonatomic, readonly) NSArray *rangeArray;

@property (nonatomic,copy) void (^updateSelectionRange)(NSRange);

@property (nonatomic,assign) NSRange selectedRange;

@property(nonatomic,strong) UIColor *tagNameColor;

@property(nonatomic,strong) UIColor *userNameColor;

@property(nonatomic,strong) UIFont *font;

@property(nonatomic,strong) UIColor *textColor;

- (NSArray *)queryElementIdList:(NSString *)elementType;

@end
