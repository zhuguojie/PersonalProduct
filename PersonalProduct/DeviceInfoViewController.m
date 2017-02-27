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
    
    // 设备型号
    NSString *model = device.model;
    
    // 设备型号
    NSString *localizedModel = device.localizedModel;
    
    // 设备系统名字
    NSString *systemName = device.systemName;
    
    // 系统版本号
    NSString *systemVersion = device.systemVersion;
    
    // UUID
    NSString *UUIDString = device.identifierForVendor.UUIDString;
    
    // 电量(负数表示当前无法设别电池电量)
    NSString *batteryLevel = [NSString stringWithFormat:@"%.2f / 100", device.batteryLevel * 100];
    
    [self addContent:[NSString stringWithFormat:@"设备名字/name: \t%@", name]];
    [self addContent:[NSString stringWithFormat:@"设备型号/model: \t%@", model]];
    [self addContent:[NSString stringWithFormat:@"设备型号/localizedModel: \t%@", localizedModel]];
    [self addContent:[NSString stringWithFormat:@"系统名字/systemName: \t%@", systemName]];
    [self addContent:[NSString stringWithFormat:@"系统版本号/systemVersion: \t%@", systemVersion]];
    [self addContent:[NSString stringWithFormat:@"UUID/identifierForVendor: \t%@", UUIDString]];
    [self addContent:[NSString stringWithFormat:@"电量/batteryLevel: \t%@", batteryLevel]];
    
    // 获取根目录
    NSString *homePath = NSHomeDirectory();
    
    // 获取 Documents 目录
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [documentsPaths objectAtIndex:0];
    
    // 获取Cache目录
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    
    // Library目录
    NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = [libraryPaths objectAtIndex:0];
    
    // temp目录
    NSString *tempPath = NSTemporaryDirectory();
    
    NSLog(@"Home目录：%@",homePath);
    NSLog(@"Documents目录：%@",documentsPath);
    NSLog(@"Cache目录：%@",cachePath);
    NSLog(@"Library目录：%@",libraryPath);
    NSLog(@"temp目录：%@",tempPath);
    
    
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

