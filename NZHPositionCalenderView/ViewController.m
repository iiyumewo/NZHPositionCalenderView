//
//  ViewController.m
//  NZHPositionCalenderView
//
//  Created by iiyumewo on 2016/12/9.
//  Copyright © 2016年 iiyumewo. All rights reserved.
//

#import "ViewController.h"
#import "CalendarView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CalendarView *calenderView = [[CalendarView alloc]initAtDate:[NSDate date] calendarStyle:CalendarViewStyleWithInfo futureLineNumber:3];
    
    [self.view addSubview:calenderView];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
