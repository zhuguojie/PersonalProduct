//
//  RichTextStorage.m
//  TextKitForView
//
//  Created by ios_zhu on 2017/1/3.
//  Copyright © 2017年 ios_zhu. All rights reserved.
//

#import "RichTextStorage.h"
#import "XMLDictionary.h"


#define TYPE_USER       @"user"
#define TYPE_HASHTAG    @"hashtag"

#define REGEX           @"<e[\\s\\S]+?/>"


@implementation RichTextStorage
{
    NSMutableAttributedString *_imp;
    NSMutableAttributedString *_richImp;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        _imp = [NSMutableAttributedString new];
        _richImp = [NSMutableAttributedString new];
        _tagNameColor = [UIColor lightGrayColor];
        _userNameColor = [UIColor lightGrayColor];
        _textColor = [UIColor blackColor];
        _font = [UIFont systemFontOfSize:16];
    }
    
    return self;
}


#pragma mark - setter

- (void)setFont:(UIFont *)font
{
    _font = font;
    
    [self edited:NSTextStorageEditedAttributes range:NSMakeRange(0, self.string.length) changeInLength:0];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    [self edited:NSTextStorageEditedAttributes range:NSMakeRange(0, self.string.length) changeInLength:0];
}

- (void)setTagNameColor:(UIColor *)tagNameColor
{
    _tagNameColor = tagNameColor;
    
    [self edited:NSTextStorageEditedAttributes range:NSMakeRange(0, self.string.length) changeInLength:0];
}

- (void)setUserNameColor:(UIColor *)userNameColor
{
    _userNameColor = userNameColor;
    
    [self edited:NSTextStorageEditedAttributes range:NSMakeRange(0, self.string.length) changeInLength:0];
}


#pragma mark - Reading Text

- (NSString *)string
{
    if (_imp == nil) {
        return @"";
    }
    
    return _imp.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_imp attributesAtIndex:location effectiveRange:range];
}

- (NSString *)richText
{
    if (_richImp == nil) {
        return @"";
    }
    
    NSMutableAttributedString *newRichText = [[NSMutableAttributedString alloc] initWithAttributedString:_richImp];
    [newRichText enumerateAttributesInRange:NSMakeRange(0, newRichText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSString *eidStr = [attrs valueForKey:@"eid"];
        NSString *title = [attrs valueForKey:@"title"];
        NSString *type = [attrs valueForKey:@"type"];
        
        if ([type isEqualToString:TYPE_HASHTAG] || [type isEqualToString:TYPE_USER]) {
            NSString *newString = [NSString stringWithFormat:@"<e eid=\"%@\" type=\"%@\" title=\"%@\" />", eidStr, type,title];
            [newRichText replaceCharactersInRange:range withString:newString];
        }
    }];
    
    return newRichText.string;
}

- (NSArray *)rangeArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSMutableAttributedString *newRichText = [[NSMutableAttributedString alloc] initWithAttributedString:_richImp];
    [newRichText enumerateAttributesInRange:NSMakeRange(0, newRichText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSString *type = [attrs valueForKey:@"type"];
        NSRange newRange = NSMakeRange(range.location, range.length + 1);
        
        if ([type isEqualToString:TYPE_HASHTAG] || [type isEqualToString:TYPE_USER]) {
            [array addObject:[NSValue valueWithRange:newRange]];
        }
    }];
    
    return array;
}


#pragma mark - Text Editing

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    // 修正 range 的边界值不在富文本中
    NSRange selectedRange = [self alignRangeWithElementList:self.rangeArray range:range];
    
    if (str.length == 0) { // 删除操作
        if (selectedRange.length != range.length ||
            selectedRange.location != range.location) {
            if (_updateSelectionRange != nil) {
                self.selectedRange = selectedRange;
                _updateSelectionRange(selectedRange);
            }
            
            return;
        }
    }

    // 计算富文本
    NSAttributedString *attributedString = [self parseRichText:str];
    
    [_richImp replaceCharactersInRange:selectedRange withAttributedString:attributedString];
    [_imp replaceCharactersInRange:selectedRange withString:attributedString.string];
    [self edited:NSTextStorageEditedCharacters range:selectedRange changeInLength:(NSInteger)attributedString.length - (NSInteger)selectedRange.length];
    
    // 记录光标位置
    NSRange selectionRange = NSMakeRange(selectedRange.location + attributedString.length, 0);
    if (attributedString.length == 0) {
        selectedRange = NSMakeRange(selectedRange.location, 0);
    }
    
    if (_updateSelectionRange != nil) {
        _updateSelectionRange(selectionRange);
    }
    
    _selectedRange = selectionRange;
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [_imp setAttributes:attrs range:range];
}

- (void)addAttributes:(NSDictionary<NSString *,id> *)attrs range:(NSRange)range
{
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [_imp addAttributes:attrs range:range];
}

- (void)setRichAttributesRange:(NSRange)range type:(NSString *)type
{
    UIColor *color;
    if ([type.lowercaseString isEqualToString:TYPE_USER]) {
        color = _userNameColor;
    }
    else if ([type.lowercaseString isEqualToString:TYPE_HASHTAG])
    {
        color = _tagNameColor;
    }
    else {
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:color forKey:NSForegroundColorAttributeName];
    [dict setValue:_font forKey:NSFontAttributeName];
    
    [self addAttributes:dict range:range];
}


#pragma mark - Syntax highlighting

- (void)processEditing
{
    NSRange paragaphRange = [self.string paragraphRangeForRange: self.editedRange];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_textColor forKey:NSForegroundColorAttributeName];
    [dict setValue:_font forKey:NSFontAttributeName];

    [self setAttributes:dict range:paragaphRange];
    
    // 更新颜色（枚举 _richText）
    NSMutableAttributedString *newRichText = [[NSMutableAttributedString alloc] initWithAttributedString:_richImp];
    [newRichText enumerateAttributesInRange:paragaphRange options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSString *type = [attrs valueForKey:@"type"];
        [self setRichAttributesRange:range type:type];
    }];
    
    [super processEditing];
}

// 解析指定的富文本 （将字符串转化为有格式的文本）
- (NSAttributedString *)parseRichText:(NSString *)richText {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    if (richText.length == 0) {
        return attributedString;
    }
    
    NSAttributedString *richAttributedText = [[NSAttributedString alloc] initWithString:richText];
    
    NSError *error = nil;
    static NSRegularExpression *regex;
    regex = regex ?: [NSRegularExpression regularExpressionWithPattern:REGEX options:0 error:&error];
    
    NSArray *matches = [regex matchesInString:richText options:0 range:NSMakeRange(0, richText.length)];
    if (matches.count == 0) {
        return richAttributedText;
    }
    
    NSUInteger offset = 0;
    
    @autoreleasepool { // 用来释放 XML
        XMLDictionaryParser *parser = [[XMLDictionaryParser alloc] init];
        
        for (NSTextCheckingResult *match in matches) {
            NSRange matchRange = match.range;
            NSAttributedString *matchString = [richAttributedText attributedSubstringFromRange:matchRange];
            NSUInteger len = matchRange.location - offset;
            
            NSAttributedString *subString = [richAttributedText attributedSubstringFromRange:NSMakeRange(offset, len)];
            [attributedString appendAttributedString:subString];
            offset += len + matchRange.length;
            
            NSDictionary *xml = [parser dictionaryWithString:matchString.string];
            
            if (xml.allKeys.count == 0) {
                [attributedString appendAttributedString:matchString];
                
                continue;
            }
            
            NSString *linkSubString = nil;
            NSString *eid;

            NSString *type = [xml attributes][@"type"];
            
            if (type.length == 0) {
                type = @"";
                NSLog(@"warning: not found type in [%@].", matchString);
            }
            
            // 拼接字符串：标签 -> #标签# 、用户 -> @用户
            if ([type isEqualToString:TYPE_HASHTAG]) { // 标签
                NSString *title = [xml attributes][@"title"];
                linkSubString = [NSString stringWithFormat:@"#%@#", title];
                
                eid = [xml attributes][@"eid"];

            } else if ([type isEqualToString:TYPE_USER]) { // 用户
                NSString *name = [xml attributes][@"title"];
                linkSubString = [NSString stringWithFormat:@"@%@", name];
                
                eid = [xml attributes][@"eid"];

            } else { // 无法识别的普通文本或者不支持的格式
                [attributedString appendAttributedString:matchString];
                linkSubString = nil;
                eid = nil;
            }
            
            if (linkSubString.length > 0) {
                NSRange newRange = NSMakeRange(attributedString.length, linkSubString.length);
                
                NSMutableDictionary *element = [[NSMutableDictionary alloc] init];
                [element setObject:linkSubString forKey:@"title"];
                [element setObject:type forKey:@"type"];
                
                if (eid != nil) { // 标签可以为空
                    [element setObject:eid forKey:@"eid"];
                }
                
                [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:linkSubString]];
                [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]]; // 标签、用户后增加一个空格
                
                [attributedString addAttributes:element range:newRange];
            }
            
            if ([match isEqual:matches.lastObject]) {
                offset = matchRange.location + matchRange.length;
                subString = [richAttributedText attributedSubstringFromRange:NSMakeRange(offset, richAttributedText.length - offset)];
                [attributedString appendAttributedString:subString];
            }
        } // end for
        
    } // end @autoreleasepool
    
    return attributedString;
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
            alignRange.length = NSMaxRange(range) - alignRange.location;
            break;
        }
    }
    
    for (NSUInteger i = elementCount; i > 0; i--) {
        NSValue *rangeValue = elementList[i - 1];
        NSRange elementRange = rangeValue.rangeValue;
        
        // 判断后面的边缘
        if (NSMaxRange(alignRange) > elementRange.location && NSMaxRange(alignRange) < NSMaxRange(elementRange)) {
            alignRange.length = NSMaxRange(elementRange) - alignRange.location;
            break;
        }
    }
    
    return alignRange;
}

- (NSArray *)queryElementIdList:(NSString *)elementType
{
    NSMutableArray *elementIdList = [NSMutableArray array];
    
    NSMutableAttributedString *newRichText = [[NSMutableAttributedString alloc] initWithAttributedString:_richImp];
    [newRichText enumerateAttributesInRange:NSMakeRange(0, newRichText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSString *eidStr = [attrs valueForKey:@"eid"];
        NSNumber *eid = [NSNumber numberWithLongLong:eidStr.longLongValue];
        NSString *type = [attrs valueForKey:@"type"];
        
        if ([type isEqualToString:elementType]) {
            [elementIdList addObject:@(eid.longLongValue)];
        }
    }];

    return elementIdList;
}


@end

