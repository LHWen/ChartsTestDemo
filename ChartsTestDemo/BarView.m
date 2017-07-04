//
//  BarView.m
//  ChartsTestDemo
//
//  Created by LHWen on 2017/7/4.
//  Copyright © 2017年 LHWen. All rights reserved.
//

#import "BarView.h"
#import "Masonry.h"
#import "ChartsTestDemo-Bridging-Header.h"   // 桥接Swift 文件
#import "ChartsTestDemo-Swift.h"             // oc 中调用 Swift 文件
#import "DateValueFormatter.h"               // 自定义 X轴 值

@interface BarView () <ChartViewDelegate>

@property (nonatomic, strong) BarChartView *barChartView;

@end

@implementation BarView
{
    NSArray *_dataArr;
    NSArray *_dataTitleArr;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
        _dataArr = @[@21, @80, @12, @33, @24, @60];
        // 月份数据 如果 X 轴值  2月  3月 4月 ... 使用以下数组
//        _dataTitleArr = @[@2, @3, @4, @5, @6, @7];
        
        // 如果自定义 X轴值 样式  如 苹果  桃子 西瓜 菠萝 ... 使用以下数组
        _dataTitleArr = @[@0, @1, @2, @3, @4, @5];  // 因为 _dataArr 只有6个值 所以 从 0 ... _dataArr.count-1
        
        
        [self setupLayout];
    }
    return self;
}

- (void)setupLayout {
    
    if (!_barChartView) {
        
        _barChartView = [[BarChartView alloc] init];
        _barChartView.delegate = self;//设置代理
        _barChartView.backgroundColor = [UIColor whiteColor];
        _barChartView.noDataText = @"暂无数据"; // 没有数据时的文字提示
        _barChartView.drawValueAboveBarEnabled = YES; // 数值显示在柱形的上面还是下面
        _barChartView.drawBarShadowEnabled = NO; // 是否绘制柱形的阴影背景
        
        
        // barChartView的交互设置
        _barChartView.scaleYEnabled = NO; // 取消Y轴缩放
        _barChartView.scaleXEnabled = NO; // 取消X轴缩放
        _barChartView.doubleTapToZoomEnabled = NO; // 取消双击缩放
        _barChartView.dragEnabled = NO; // 启用拖拽图表
        [_barChartView setExtraOffsetsWithLeft:5 top:10 right:20 bottom:0];
        [self addSubview:_barChartView];
        [self.barChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.center.equalTo(self);
            make.height.equalTo(@300);
        }];
        
        // 设置动画效果，可以设置X轴和Y轴的动画效果
        [_barChartView animateWithYAxisDuration:1.75f];
        
        // X 轴 的设置
        ChartXAxis *xAxis = _barChartView.xAxis;
        xAxis.axisLineWidth = 0;   // 设置X轴线宽
        xAxis.labelPosition = XAxisLabelPositionBottom;  // X轴的显示位置，默认是显示在上面的
        xAxis.drawGridLinesEnabled = NO;    //  不绘制网格线
        //    xAxis.spaceMin = 1;//设置label间隔，若设置为1，则如果能全部显示，则每个柱形下面都会显示label
        xAxis.labelTextColor = [UIColor orangeColor]; //label文字颜色
        
        // 月份数据 如果 X 轴值  2月  3月 4月 ... 使用以下数组
        /***
        NSNumberFormatter *xAxisFormatter = [[NSNumberFormatter alloc] init];
        xAxisFormatter.positiveSuffix = @"月";
        xAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:xAxisFormatter];
        */
        
        // 使用自定义 X轴值
        NSMutableArray *xVals = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < _dataArr.count; i++) {
            [xVals addObject: [NSString stringWithFormat:@"样式%d", i + 1]];
        }
        xAxis.valueFormatter = [[DateValueFormatter alloc] initWithArr:[xVals copy]];
        
        _barChartView.rightAxis.enabled = NO; // 不绘制右边轴
        _barChartView.leftAxis.enabled = YES;  // 是否绘制左边轴
        ChartYAxis *leftAxis = _barChartView.leftAxis; // 获取左边Y轴
        leftAxis.labelCount = 6; // Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
        leftAxis.forceLabelsEnabled = YES;  // 不强制绘制指定数量的label
        leftAxis.inverted = NO;   // 是否将Y轴进行上下翻转
        leftAxis.axisLineColor = [UIColor clearColor]; // Y轴颜色
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart; // label位置
        leftAxis.labelTextColor = [UIColor greenColor];         // 文字颜色
        leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];    // 文字字体
        leftAxis.gridColor = [UIColor yellowColor]; // 网格线颜色
        leftAxis.gridAntialiasEnabled = YES;        // 开启抗锯齿
        [leftAxis setXOffset:10.0f];
        
        _barChartView.legend.enabled = NO;    // 是否 显示图例说明
        _barChartView.descriptionText = @"";  // 对于显示的图描述 不显示，就设为空字符串即可
        
        // 气泡显示 用的是 Charts demo中的两个Swift 文件， 已经将直角，变为圆角
        XYMarkerView *marker = [[XYMarkerView alloc] initWithColor:[UIColor blueColor]
                                                              font:[UIFont systemFontOfSize:12.0]
                                                         textColor:UIColor.whiteColor
                                                            insets:UIEdgeInsetsMake(3.0, 3.0, 16.0, 3.0)
                                               xAxisValueFormatter:_barChartView.xAxis.valueFormatter];
        marker.chartView = _barChartView;
        marker.minimumSize = CGSizeMake(30.0f, 15.0f);
        _barChartView.marker = marker;
        
        [self setData];
    }
}

- (void)setData {
    
    //对应Y轴上面需要显示的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < _dataArr.count; i++) {
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:[_dataTitleArr[i] doubleValue]
                                                                      y:[_dataArr[i] doubleValue]
                                                                   icon:[UIImage imageNamed:@""]];
        [yVals addObject:entry];
    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithValues:yVals label:@"The year 2017"];
    
    [set1 setColor:[UIColor blueColor]]; // 设置柱子颜色
    set1.highlightColor = [UIColor orangeColor];   // 选中时高亮的颜色
    
    set1.drawValuesEnabled = NO; // 是否在柱形图上面显示数值
    set1.highlightEnabled = YES; // 点击选中柱形图是否有高亮效果，（双击空白处取消选中）
    
    set1.drawIconsEnabled = NO;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    data.barWidth = 0.5f;
    
    //为柱形图提供数据
    _barChartView.data = data;
    
    // 默认高亮坐标 注释掉 将不会有默认选项
    [_barChartView highlightValue:[[ChartHighlight alloc] initWithX:[_dataTitleArr[_dataTitleArr.count - 1] doubleValue]
                                                               y:[_dataArr[_dataArr.count - 1] doubleValue]
                                                     dataSetIndex:0]];
}

// 点击选中柱形图时的代理方法，代码如下：
- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight {
    NSLog(@"---chartValueSelected---value: %g", entry.x);
}


@end
