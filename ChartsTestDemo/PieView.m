//
//  PieView.m
//  ChartsTestDemo
//
//  Created by LHWen on 2017/7/4.
//  Copyright © 2017年 LHWen. All rights reserved.
//

#import "PieView.h"
#import "Masonry.h"
#import "ChartsTestDemo-Bridging-Header.h"   // 桥接Swift 文件

@interface PieView ()

@property (nonatomic, strong) PieChartView *pieChartView;

@end

@implementation PieView
{
    NSArray *_dataArr;
    NSArray *_dataTitleArr;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
        _dataArr = @[@"23", @"46", @"21"];
        _dataTitleArr = @[@"苹果 23", @"桃子 46", @"荔枝 21"];
        
        [self setupLayout];
    }
    return self;
}

- (void)setupLayout {
    
    if (!_pieChartView) {
     
        _pieChartView = [[PieChartView alloc] init];
        _pieChartView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.pieChartView];
        [_pieChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300, 300));
            make.center.mas_equalTo(self);
        }];
        
        [_pieChartView setExtraOffsetsWithLeft:20 top:0 right:20 bottom:0]; // 饼状图距离边缘的间隙
        _pieChartView.usePercentValuesEnabled = YES; // 是否根据所提供的数据, 将显示数据转换为百分比格式
        _pieChartView.dragDecelerationEnabled = NO;  // 拖拽饼状图后是否有惯性效果
        _pieChartView.drawSliceTextEnabled = YES;    // 是否显示区块文本
        
        _pieChartView.drawHoleEnabled = YES;   // 饼状图是否是空心
        _pieChartView.holeRadiusPercent = 0.5; // 空心半径占比
        _pieChartView.holeColor = [UIColor clearColor];     // 空心颜色
        _pieChartView.transparentCircleRadiusPercent = 0.52; // 半透明空心半径占比
        _pieChartView.transparentCircleColor = [UIColor colorWithRed:210/255.0 green:145/255.0 blue:165/255.0 alpha:0.3]; // 半透明空心的颜色
        
        _pieChartView.descriptionText = @"饼状图示例";
        _pieChartView.descriptionFont = [UIFont systemFontOfSize:10];
        _pieChartView.descriptionTextColor = [UIColor grayColor];
        
        _pieChartView.legend.enabled = YES;       // 是否绘制图例 (默认绘制)
        _pieChartView.legend.maxSizePercent = 1;   // 图例在饼状图中的大小占比, 这会影响图例的宽高
        _pieChartView.legend.formToTextSpace = 5;  // 文本间隔
        _pieChartView.legend.font = [UIFont systemFontOfSize:10]; // 字体大小
        _pieChartView.legend.textColor = [UIColor whiteColor];     // 字体颜色
        _pieChartView.legend.position = ChartLegendPositionBelowChartCenter; // 图例在饼状图中的位置
        _pieChartView.legend.form = ChartLegendFormCircle;  // 图示样式: 方形、线条、圆形
        _pieChartView.legend.formSize = 12;  // 图示大小
        
        // 设置动画效果
        [_pieChartView animateWithXAxisDuration:1.0f easingOption:ChartEasingOptionEaseOutExpo];
        
        // 为饼状图提供数据
        [self setData];
    }
}

// 设置数据
- (void)setData {
    
    NSMutableArray *values = [[NSMutableArray alloc] init];   // 存储数据数组
    for (int i = 0; i < _dataArr.count; i++) {
        
        [values addObject:[[PieChartDataEntry alloc] initWithValue:[_dataArr[i] doubleValue]
                                                             label:_dataTitleArr[i]
                                                              icon: [UIImage imageNamed:@"icon"]]];
    }
    
    // 以下是设置 饼图颜色 折线指示属性
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Election Results"];
    
    dataSet.drawIconsEnabled = YES;
    dataSet.sliceSpace = 2.0;
    dataSet.iconsOffset = CGPointMake(0, 40);
    
    // add a lot of colors
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    /** 设置自定义的颜色 */
    [colors addObject:[UIColor redColor]];
    [colors addObject:[UIColor orangeColor]];
    [colors addObject:[UIColor blueColor]];
    /** charts 中的颜色 */
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    
    dataSet.colors = colors;
    
    dataSet.sliceSpace = 0;     // 相邻区块之间的间距
    dataSet.selectionShift = 8; // 选中区块时, 放大的半径
    dataSet.xValuePosition = PieChartValuePositionInsideSlice;  // 名称位置
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice; // 数据位置
    dataSet.valueLinePart1OffsetPercentage = 0.85; // 折线中第一段起始位置相对于区块的偏移量, 数值越大, 折线距离区块越远
    dataSet.valueLinePart1Length = 0.5; // 折线中第一段长度占比
    dataSet.valueLinePart2Length = 0.4; // 折线中第二段长度最大占比
    dataSet.valueLineWidth = 1;  // 折线的粗细
    dataSet.valueLineColor = [UIColor whiteColor]; // 折线颜色
    
    // pieChartView Data 初始化
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.whiteColor];
    
    _pieChartView.data = data;
}

@end
