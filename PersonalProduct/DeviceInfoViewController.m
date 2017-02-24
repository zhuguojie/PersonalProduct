//
//  DeviceInfoViewController.m
//  PersonalProduct
//
//  Created by ios_zhu on 2017/2/24.
//  Copyright © 2017年 ios_zhu. All rights reserved.
//

#import "DeviceInfoViewController.h"


@interface DeviceInfoViewController ()

@property(nonatomic,copy) NSString *content;

@end


@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"UIDevice 信息";
    
    _content = @"当前设备信息：";
    
    UIDevice *device = [UIDevice currentDevice];
    
    // 设备名字，用户给手机的命名
    NSString *name = device.name;
    [self addContent:[NSString stringWithFormat:@"设备名字/name: \t%@", name]];
    
    // 设备型号
    NSString *model = device.model;
    [self addContent:[NSString stringWithFormat:@"设备型号/model: \t%@", model]];
    
    // 设备型号
    NSString *localizedModel = device.localizedModel;
    [self addContent:[NSString stringWithFormat:@"设备型号/localizedModel: \t%@", localizedModel]];
    
    // 设备系统名字
    NSString *systemName = device.systemName;
    [self addContent:[NSString stringWithFormat:@"系统名字/systemName: \t%@", systemName]];
    
    // 系统版本号
    NSString *systemVersion = device.systemVersion;
    [self addContent:[NSString stringWithFormat:@"系统版本号/systemVersion: \t%@", systemVersion]];
    
    // UUID
    NSString *UUIDString = device.identifierForVendor.UUIDString;
    [self addContent:[NSString stringWithFormat:@"UUID/identifierForVendor: \t%@", UUIDString]];
    
    // 电量(负数表示当前无法设别电池电量)
    NSString *batteryLevel = [NSString stringWithFormat:@"%.2f / 100", device.batteryLevel * 100];
    [self addContent:[NSString stringWithFormat:@"电量/batteryLevel: \t%@", batteryLevel]];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = self.view.bounds;
    label.numberOfLines = 0;
    label.text = _content;
    
    [self.view addSubview:label];
}

- (void)addContent:(NSString *)content
{
    _content = [_content stringByAppendingFormat:@"\n\n%@", content];
}

@end

