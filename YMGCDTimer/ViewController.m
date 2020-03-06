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
    
    self.timer = [YMGCDTimer timerWithTimeInterval:1 repeats:YES block:^(NSUInteger count) {
        NSLog(@"yuman : %@", @(count));
    }];
    
    [self.timer start];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.timer pause];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.timer start];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.timer = nil;
    });
}

@end
