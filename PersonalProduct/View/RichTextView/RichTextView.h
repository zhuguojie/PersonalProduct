//
//  RichTextView.h
//  TextKitForView
//
//  Created by ios_zhu on 2017/2/15.
//  Copyright © 2017年 ios_zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RichTextViewDelegate;


@interface RichTextView : UITextView

@property(nonatomic,copy, readonly) NSString *richText;

@property(nonatomic,assign) NSInteger allowedMaxTextCount; // 最大字符数，0 为无限制

@property(nonatomic,strong) UIColor *tagNameColor;

@property(nonatomic,strong) UIColor *userNameColor;

@property(nonatomic,weak) id<RichTextViewDelegate> textViewDelegate;


- (void)insertRichText:(NSString *)richText;

- (void)replacingCharactersInRange:(NSRange)range withString:(NSString *)replacement;

- (NSArray *)queryElementIdList:(NSString *)elementType;

@end


@protocol RichTextViewDelegate <NSObject>

@optional

- (BOOL)textView:(RichTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewDidChange:(RichTextView *)textView;
- (void)touchesBegan:(NSSet *)touches;

@end

