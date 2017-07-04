//
//  BarChartsViewController.m
//  ChartsTestDemo
//
//  Created by LHWen on 2017/7/4.
//  Copyright © 2017年 LHWen. All rights reserved.
//

#import "BarChartsViewController.h"
#import "Masonry.h"
#import "BarView.h"

@interface BarChartsViewController ()

@end

@implementation BarChartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Charts 柱状图";
    self.view.backgroundColor = [UIColor whiteColor];
    
    BarView *barView = [[BarView alloc] init];
    barView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:barView];
    [barView mas_makeConstraints:^(MASConstraintMaker *make) {
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
