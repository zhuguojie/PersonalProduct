//
//  ViewController.m
//  PersonalProduct
//
//  Created by ios_zhu on 2017/2/24.
//  Copyright © 2017年 ios_zhu. All rights reserved.
//

#import "MainViewController.h"
#import "DeviceInfoViewController.h"


@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@end


@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Demo 列表";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行", indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceInfoViewController *deviceInfoViewController = [[DeviceInfoViewController alloc] init];
    
    [self.navigationController pushViewController:deviceInfoViewController animated:YES];
}

@end


