//
//  ViewController.m
//  PersonalProduct
//
//  Created by ios_zhu on 2017/2/24.
//  Copyright © 2017年 ios_zhu. All rights reserved.
//

#import "MainViewController.h"
#import "DeviceInfoViewController.h"
#import "TypeConversionViewController.h"
#import "MultiPictureViewController.h"
#import "RichTextViewController.h"


@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_dataSource;
}

@property(nonatomic,strong) UITableView *tableView;

@end


@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Demo 列表";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataSource = @[@"设备信息", @"类型转换", @"多图展示", @"富文本展示"];
    
    [self.tableView reloadData];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = _dataSource[indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        DeviceInfoViewController *viewController = [[DeviceInfoViewController alloc] init];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 1) {
        TypeConversionViewController *viewController = [[TypeConversionViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 2) {
        MultiPictureViewController *viewController = [[MultiPictureViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 3) {
        RichTextViewController *viewController = [[RichTextViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end


