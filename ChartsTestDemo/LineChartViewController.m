//
//  LineChartViewController.m
//  ChartsTestDemo
//
//  Created by LHWen on 2017/7/4.
//  Copyright © 2017年 LHWen. All rights reserved.
//

#import "LineChartViewController.h"
#import "Masonry.h"
#import "LineView.h"

@interface LineChartViewController ()

@end

@implementation LineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Charts 折线图";
    self.view.backgroundColor = [UIColor whiteColor];
    
    LineView *lineView = [[LineView alloc] init];
    lineView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
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
