//
//  RichTextViewController.m
//  PersonalProduct
//
//  Created by ios_zhu on 2017/3/7.
//  Copyright © 2017年 ios_zhu. All rights reserved.
//

#import "RichTextViewController.h"
#import "RichTextView.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface RichTextViewController () <RichTextViewDelegate>
{
    RichTextView *_textView;
    UITextField *_textField;
    UILabel *_richTextLabel;
}


@end


@implementation RichTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textField = [[UITextField alloc] init];
    _textField.backgroundColor = UIColorFromRGB(0xf5f6f7);
    [self.view addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(70);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = UIColorFromRGB(0xf5f6f7);
    [button setTitle:@"插入用户" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:UIColorFromRGB(0x16b998) forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textField.mas_bottom).with.offset(5);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
        make.left.mas_equalTo(20);
    }];
    
    UIButton *insertTagButton = [UIButton buttonWithType:UIButtonTypeCustom];
    insertTagButton.backgroundColor = UIColorFromRGB(0xf5f6f7);
    [insertTagButton setTitle:@"插入标签" forState:UIControlStateNormal];
    [insertTagButton addTarget:self action:@selector(insertTagButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [insertTagButton setTitleColor:UIColorFromRGB(0x16b998) forState:UIControlStateNormal];
    [self.view addSubview:insertTagButton];
    [insertTagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textField.mas_bottom).with.offset(5);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
        make.centerX.mas_equalTo(self.view);
    }];
    
    UIButton *printButton = [UIButton buttonWithType:UIButtonTypeCustom];
    printButton.backgroundColor = UIColorFromRGB(0xf5f6f7);
    [printButton setTitle:@"打印富文本" forState:UIControlStateNormal];
    [printButton addTarget:self action:@selector(printButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [printButton setTitleColor:UIColorFromRGB(0x16b998) forState:UIControlStateNormal];
    [self.view addSubview:printButton];
    [printButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textField.mas_bottom).with.offset(5);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(100);
        make.right.mas_equalTo(-20);
    }];
    

    _textView = [[RichTextView alloc] init];
    _textView.backgroundColor = UIColorFromRGB(0xf5f6f7);
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.textColor = [UIColor blackColor];
    _textView.tagNameColor = UIColorFromRGB(0x567895);
    _textView.userNameColor = UIColorFromRGB(0x16b998);
    _textView.textContainerInset = UIEdgeInsetsMake(13, 13, 5, 5);
    _textView.textViewDelegate = self;
    _textView.returnKeyType = UIReturnKeyDefault;
    _textView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(button.mas_bottom).with.offset(10);
        make.height.mas_equalTo(200);
    }];
    
    _richTextLabel = [[UILabel alloc] init];
    _richTextLabel.backgroundColor = UIColorFromRGB(0xf5f6f7);
    _richTextLabel.numberOfLines = 0;
    [self.view addSubview:_richTextLabel];
    [_richTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textView.mas_bottom).with.offset(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(20);
    }];
}

- (void)buttonClicked:(UIButton *)sender
{
    [_textField resignFirstResponder];
    [_textView becomeFirstResponder];
    
    NSString *richText = _textField.text;
    if (richText.length == 0) {
        richText = @"用户名";
    }
    
    richText = [NSString stringWithFormat:@"<e title='%@' eid='001' type='user'/>", richText];
    
    [_textView insertRichText:richText];
}

- (void)insertTagButtonClicked:(UIButton *)sender
{
    [_textField resignFirstResponder];
    [_textView becomeFirstResponder];
    
    NSString *richText = _textField.text;
    if (richText.length == 0) {
        richText = @"标签";
    }
    
    richText = [NSString stringWithFormat:@"<e title='%@' eid='001' type='hashtag'/>", richText];
    
    [_textView insertRichText:richText];
}

- (void)printButtonClicked:(UIButton *)sender
{
    _richTextLabel.text = [NSString stringWithFormat:@"富文本为：\n%@", _textView.richText];
}

@end
