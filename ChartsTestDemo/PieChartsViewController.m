//
//  PieChartsViewController.m
//  ChartsTestDemo
//
//  Created by LHWen on 2017/7/4.
//  Copyright © 2017年 LHWen. All rights reserved.
//

#import "PieChartsViewController.h"
#import "Masonry.h"
#import "PieView.h"

@interface PieChartsViewController ()

@end

@implementation PieChartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Charts 饼图";
    self.view.backgroundColor = [UIColor whiteColor];
    
    PieView *pieView = [[PieView alloc] init];
    pieView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:pieView];
    [pieView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@(self.view.bounds.size.width));
        make.height.equalTo(@400);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
