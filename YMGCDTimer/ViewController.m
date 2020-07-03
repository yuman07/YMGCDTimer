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
    
    self.timer = [YMGCDTimer timerWithTimeInterval:10 repeats:YES block:^(NSUInteger count) {
        NSLog(@"yuman : %@ : %@", @(count), @([[NSDate date] timeIntervalSince1970]));
    }];
    
    [self.timer start];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.timer pause];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.timer start];
        });
    });
}

@end
