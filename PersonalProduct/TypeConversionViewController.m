//
//  TypeConversionViewController.m
//  PersonalProduct
//
//  Created by ios_zhu on 2017/2/27.
//  Copyright © 2017年 ios_zhu. All rights reserved.
//

#import "TypeConversionViewController.h"


@interface TypeConversionViewController ()
{
    UITextField *_textField;
    UIButton *_conversionButton;
    UILabel *_contentLabel;
}

@end


@implementation TypeConversionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"类型转换";
    
    _textField = [[UITextField alloc] init];
    [_textField becomeFirstResponder];
    [self.view addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-100);
        make.height.mas_equalTo(50);
    }];
    
    _conversionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _conversionButton.backgroundColor = [UIColor grayColor];
    [_conversionButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_conversionButton setTitle:@"转换" forState:UIControlStateNormal];
    [self.view addSubview:_conversionButton];
    [_conversionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(50);
    }];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.numberOfLines = 0;
    [self.view addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textField.mas_bottom).with.offset(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(20);
    }];
}

-(void)buttonClicked:(UIButton *)sender
{
    NSString *text = _textField.text;
    
    NSNumber *number = [NSNumber numberWithFloat:text.floatValue];
    NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithString:text];
    
    NSString *content = [NSString stringWithFormat:@"NSNumber 转换: %@\n", number];
    content = [content stringByAppendingFormat:@"NSDecimalNumber 转换:%@", decimalNumber];
    
    _contentLabel.text = content;
}

@end


