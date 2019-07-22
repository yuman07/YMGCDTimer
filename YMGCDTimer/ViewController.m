//
//  ViewController.m
//  YMGCDTimer
//
//  Created by yuman01 on 2019/7/18.
//  Copyright © 2019 yuman01. All rights reserved.
//

#import "ViewController.h"
#import "YMGCDTimer/YMGCDTimer.h"

@interface ViewController ()

@property (nonatomic, strong) YMGCDTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.timer = [YMGCDTimer timerWithTimeInterval:2 repeats:YES block:^{
        NSLog(@"123");
        self.timer = nil;  // 自动停止
    }];
}

@end
