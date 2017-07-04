//
//  DateValueFormatter.h
//  ChartsTestDemo
//
//  Created by LHWen on 2017/7/4.
//  Copyright © 2017年 LHWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartsTestDemo-Bridging-Header.h"

// 自定义 X轴
@interface DateValueFormatter : NSObject <IChartAxisValueFormatter>

- (id)initWithArr:(NSArray *)arr;

@end
