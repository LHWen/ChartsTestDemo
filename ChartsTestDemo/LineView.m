//
//  LineView.m
//  ChartsTestDemo
//
//  Created by LHWen on 2017/7/4.
//  Copyright © 2017年 LHWen. All rights reserved.
//

#import "LineView.h"
#import "Masonry.h"
#import "ChartsTestDemo-Bridging-Header.h"   // 桥接Swift 文件
#import "ChartsTestDemo-Swift.h"             // oc 中调用 Swift 文件

@interface LineView () <ChartViewDelegate>

@property (nonatomic, strong) LineChartView *lineChartView;

@end

@implementation LineView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
        [self setupLayout];
    }
    return self;
}

- (void)setupLayout {
    
    if (!_lineChartView) {
        
        _lineChartView = [[LineChartView alloc] init];
        _lineChartView.delegate = self; // 设置代理
        _lineChartView.backgroundColor =  [UIColor whiteColor];
        _lineChartView.noDataText = @"暂无数据";
        _lineChartView.chartDescription.enabled = YES;
        _lineChartView.scaleYEnabled = NO;  //  取消Y轴缩放
        _lineChartView.scaleXEnabled = NO;  // 取消X轴缩放
        _lineChartView.doubleTapToZoomEnabled = NO; // 取消双击缩放
        _lineChartView.dragEnabled = NO;  // 关闭拖拽图标
        [_lineChartView setExtraOffsetsWithLeft:13 top:20 right:40 bottom:0];
        
        //描述及图例样式
        [_lineChartView setDescriptionText:@""];
        _lineChartView.legend.enabled = NO;  // 是否开启图例
        
        // 展现动画
        [_lineChartView animateWithYAxisDuration:1.75f];
        
        [self addSubview:_lineChartView];
        [_lineChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.center.equalTo(self);
            make.height.equalTo(@300.0f);
        }];
        
        _lineChartView.rightAxis.enabled = NO; // 不绘制右边轴
        _lineChartView.leftAxis.enabled = YES;  // 绘制左边轴
        ChartYAxis *leftAxis = _lineChartView.leftAxis; // 获取左边Y轴
        leftAxis.labelCount = 6; // Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
        leftAxis.forceLabelsEnabled = YES;  // 不强制绘制指定数量的label
        leftAxis.inverted = NO;   // 是否将Y轴进行上下翻转
        leftAxis.axisLineColor = [UIColor clearColor]; // Y轴颜色
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart; // label位置
        leftAxis.labelTextColor = [UIColor orangeColor];        // 文字颜色
        leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];   // 文字字体
        leftAxis.gridColor = [UIColor grayColor]; // 网格线颜色
        leftAxis.gridAntialiasEnabled = YES; // 开启抗锯齿
        [leftAxis setXOffset:15.0f];
        
        // X轴设置
        ChartXAxis *xAxis = _lineChartView.xAxis;
        xAxis.granularityEnabled = YES;  //  设置重复的值不显示
        xAxis.labelPosition = XAxisLabelPositionBottom; //  设置x轴数据在底部
        xAxis.gridColor = [UIColor clearColor];
        xAxis.labelTextColor = [UIColor greenColor]; //文字颜色
        xAxis.axisLineColor = [UIColor clearColor];  // x轴颜色
        NSNumberFormatter *xAxisFormatter = [[NSNumberFormatter alloc] init];
        xAxisFormatter.positiveSuffix = @"月";
        xAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:xAxisFormatter];
        _lineChartView.maxVisibleCount = 999;//设置能够显示的数据数量
        
        // 设置选中时气泡
        XYMarkerView *marker = [[XYMarkerView alloc] initWithColor:[UIColor greenColor]
                                                              font:[UIFont systemFontOfSize:12.0]
                                                         textColor:UIColor.whiteColor
                                                            insets:UIEdgeInsetsMake(3, 3, 16.0, 3)
                                               xAxisValueFormatter:_lineChartView.xAxis.valueFormatter];
        marker.chartView = _lineChartView;
        marker.minimumSize = CGSizeMake(30.0f, 15.0f);
        _lineChartView.marker = marker;
        
        [self setData];
    }
}

// 设置数据
- (void)setData {
    
    NSArray *dataArr = @[@210, @130.5, @160.3, @93, @84, @160];
    NSArray *yueArr = @[@2, @3, @4, @5, @6, @7];
    
    //对应Y轴上面需要显示的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < dataArr.count; i++) {
        
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:[yueArr[i] doubleValue] y:[dataArr[i] doubleValue]];
        [yVals addObject:entry];
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc]initWithValues:yVals label:nil];
    //设置折线的样式
    set1.lineWidth = 2.0f; // 折线宽度
    set1.drawValuesEnabled = NO; // 是否在拐点处显示数据
    set1.valueColors = @[[UIColor brownColor]]; // 折线拐点处显示数据的颜色
    [set1 setColor:[UIColor blueColor]]; // 折线颜色
    [set1 setCircleColor:[UIColor orangeColor]]; // 拐点 圆的颜色
    set1.circleRadius = 7.0f;
    set1.highlightColor = [UIColor clearColor];
    set1.drawSteppedEnabled = NO; // 是否开启绘制阶梯样式的折线图
    // 折线拐点样式
    set1.drawCirclesEnabled = YES; // 是否绘制拐点
    set1.drawFilledEnabled = NO; // 是否填充颜色
    
    // 将 LineChartDataSet 对象放入数组中
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    LineChartData *data = [[LineChartData alloc]initWithDataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.0f]]; // 文字字体
    [data setValueTextColor:[UIColor blackColor]]; // 文字颜色
    
    _lineChartView.data = data;
    
    [_lineChartView highlightValue:[[ChartHighlight alloc] initWithX:[yueArr[yueArr.count - 1] doubleValue] y:[dataArr[dataArr.count - 1] doubleValue] dataSetIndex:0]];
    
}

- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight {
    
    NSLog(@"---chartValueSelected---value: %g", entry.x);
}


@end
