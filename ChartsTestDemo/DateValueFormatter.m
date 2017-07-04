//
//  DateValueFormatter.m
//  ChartsTestDemo
//
//  Created by LHWen on 2017/7/4.
//  Copyright © 2017年 LHWen. All rights reserved.
//

#import "DateValueFormatter.h"

@implementation DateValueFormatter
{
    NSArray *_arr;
}

- (id)initWithArr:(NSArray *)arr {
    self = [super init];
    
    if (self)  {
        _arr = arr;
        
    }
    return self;
}

// 方法写
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    
    return _arr[(NSInteger)value];
}

@end
