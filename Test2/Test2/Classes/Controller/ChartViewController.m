//
//  ChartViewController.m
//  Test2
//
//  Created by Alex Tran on 8/26/15.
//  Copyright (c) 2015 Alex Tran. All rights reserved.
//

#import "ChartViewController.h"
#import <PNChart/PNChart.h>

@interface ChartViewController ()
- (IBAction)touchBack:(id)sender;

@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //For Line Chart
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 300)];
    [lineChart setXLabels:_days];
    
    // Line Chart No.1
    NSArray * data01Array = _currencyRates;
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };

    [lineChart setXLabelWidth:30.0f];
    [lineChart setXLabelFont:[UIFont systemFontOfSize:10.0f]];
//    NSNumber* min = [_currencyRates valueForKeyPath:@"@min.self"];
//    NSNumber* max = [_currencyRates valueForKeyPath:@"@max.self"];
//    [lineChart setYValueMax:[max floatValue]];
//    [lineChart setYValueMin:[min floatValue]];
    
    lineChart.chartData = @[data01];
    [lineChart strokeChart];
    
    [self.view addSubview:lineChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Touch Action
- (IBAction)touchBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
