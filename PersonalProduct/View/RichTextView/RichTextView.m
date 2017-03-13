//
//  RichTextView.m
//  TextKitForView
//
//  Created by ios_zhu on 2017/2/15.
//  Copyright © 2017年 ios_zhu. All rights reserved.
//

#import "RichTextView.h"
#import "RichTextStorage.h"

@interface RichTextView () <UITextViewDelegate>
{
    
}

@property (nonatomic,strong) RichTextStorage *richTextStorage;

@end


@implementation RichTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    if (textContainer == nil) {
        
        textContainer = [[NSTextContainer alloc] init];
    }
    
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    
    _richTextStorage = [[RichTextStorage alloc] init];
    [_richTextStorage addLayoutManager:layoutManager];
    
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        __weak typeof(self) weakSelf = self;
        _richTextStorage.updateSelectionRange = ^(NSRange selectedRange){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.markedTextRange == nil) {
                    weakSelf.selectedRange= selectedRange;
                }
            });
        };
        
        self.delegate = self;
    }
    
    return self;
}

- (void)setText:(NSString *)text
{
    [_richTextStorage replaceCharactersInRange:NSMakeRange(0, self.text.length) withString:text];
    
    if ([self.textViewDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.textViewDelegate textViewDidChange:self];
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    
    _richTextStorage.textColor = textColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    _richTextStorage.font = font;
}

- (NSString *)richText
{
    return _richTextStorage.richText;
}

- (void)setTagNameColor:(UIColor *)tagNameColor
{
    _tagNameColor = tagNameColor;
    _richTextStorage.tagNameColor = tagNameColor;
}

- (void)setUserNameColor:(UIColor *)userNameColor
{
    _userNameColor = userNameColor;
    _richTextStorage.userNameColor = userNameColor;
}

- (void)insertRichText:(NSString *)richText
{
    NSRange selectedRange = self.selectedRange;
    
    [self replacingCharactersInRange:selectedRange withString:richText];
}

- (void)replacingCharactersInRange:(NSRange)range withString:(NSString *)replacement
{
    if (_richTextStorage.string.length < NSMaxRange(range)) {
        return;
    }
    
    [_richTextStorage replaceCharactersInRange:range withString:replacement];
    
    if ([self.textViewDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.textViewDelegate textViewDidChange:self];
    }
}

- (NSArray *)queryElementIdList:(NSString *)elementType
{
    NSArray *elementIdList = [_richTextStorage queryElementIdList:elementType];
    
    return elementIdList;
}

- (BOOL)textView:(RichTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.markedTextRange == nil) {
        if (_allowedMaxTextCount > 0 && text.length > 0 && ![text isEqualToString:@"\n"]) { // 检查字符数是否超长
            if (textView.richText.length > _allowedMaxTextCount) {
                return NO;
            }
        }
    }
    
    BOOL result = YES;
    if ([self.textViewDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        result = [self.textViewDelegate textView:self shouldChangeTextInRange:range replacementText:text];
    }
    
    return result;
}

- (void)textViewDidChange:(RichTextView *)textView
{
    if ([self.textViewDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.textViewDelegate textViewDidChange:self];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [super touchesBegan:touches withEvent:event];
    
    if ([self.textViewDelegate respondsToSelector:@selector(touchesBegan:)]) {
        [self.textViewDelegate touchesBegan:touches];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (textView.markedTextRange != nil) { // 中文的输入还没有完成
        return;
    }
    
    NSRange selectedRange = [self alignRangeWithElementList:_richTextStorage.rangeArray range:self.selectedRange];
    
    if (self.selectedRange.location == selectedRange.location &&
        self.selectedRange.length == selectedRange.length) {
        return;
    }
    
    self.selectedRange = selectedRange;
}

// 修正指定范围的边缘（可能有某些元素刚好落在指定范围的边缘）
- (NSRange)alignRangeWithElementList:(NSArray *)elementList range:(NSRange)range
{
    NSRange alignRange = range;
    
    NSUInteger elementCount = elementList.count;
    for (NSUInteger i = 0; i < elementCount; i++) {
        NSValue *rangeValue = elementList[i];
        NSRange elementRange = rangeValue.rangeValue;
        
        // 判断前面的边缘
        if (NSLocationInRange(range.location, elementRange)) {
            alignRange.location = elementRange.location;
            
            break;
        }
    }
    
    if (range.length > 0) {
        for (NSUInteger i = elementCount; i > 0; i--) {
            NSValue *rangeValue = elementList[i - 1];
            NSRange elementRange = rangeValue.rangeValue;
            
            // 判断后面的边缘
            if (NSMaxRange(alignRange) > elementRange.location && NSMaxRange(alignRange) < NSMaxRange(elementRange)) {
                alignRange.length = NSMaxRange(elementRange) - alignRange.location;
                
                break;
            }
        }
    }
    
    return alignRange;
}


#pragma mark - Menu action

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(selectAll:) ||
        action == @selector(select:) ||
        action == @selector(copy:) ||
        action == @selector(paste:) ||
        action == @selector(delete:) ||
        action == @selector(cut:)) {
        
        return [super canPerformAction:action withSender:sender];
    }
    
    return NO;
}

@end

