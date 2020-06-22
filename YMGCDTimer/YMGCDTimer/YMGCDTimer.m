//
//  YMGCDTimer.m
//  
//
//  Created by yuman on 2019/7/18.
//  Copyright © 2019 yuman. All rights reserved.
//

#import "YMGCDTimer.h"

typedef NS_ENUM(NSInteger, YMGCDTimerState) {
    YMGCDTimerStateInit,
    YMGCDTimerStateRunning,
    YMGCDTimerStatePause,
    YMGCDTimerStateStop,
};

@interface YMGCDTimer ()

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) YMGCDTimerState state;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation YMGCDTimer

+ (YMGCDTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void(^)(NSUInteger count))block
{
    if (isnan(interval) || isinf(interval) || interval < 0 || !block) {
        return nil;
    }
    return [[YMGCDTimer alloc] initWithTimeInterval:interval repeats:repeats block:block];
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void(^)(NSUInteger count))block
{
    self = [super init];
    if (self) {
        _interval = interval;
        _lock = [[NSLock alloc] init];
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(_timer, ^{
            __strong typeof(self) self = weakSelf;
            if (!self) {
                return;
            }
            if (!repeats) {
                [self stop];
            }
            if (block) {
                block(self->_count++);
            }
        });
    }
    return self;
}

- (void)dealloc
{
    [self stop];
}

- (void)start
{
    [self.lock lock];
    
    if (self.state == YMGCDTimerStateInit) {
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, _interval * NSEC_PER_SEC), _interval * NSEC_PER_SEC, 0);
        dispatch_resume(_timer);
        self.state = YMGCDTimerStateRunning;
    }
    
    if (self.state == YMGCDTimerStatePause) {
        dispatch_resume(_timer);
        self.state = YMGCDTimerStateRunning;
    }
    
    [self.lock unlock];
}

- (void)pause
{
    [self.lock lock];
    
    if (self.state == YMGCDTimerStateRunning) {
        dispatch_suspend(_timer);
        self.state = YMGCDTimerStatePause;
    }
    
    [self.lock unlock];
}

- (void)stop
{
    [self.lock lock];
    
    if (self.state != YMGCDTimerStateStop) {
        if (self.state != YMGCDTimerStateRunning) {
            dispatch_resume(_timer);
        }
        dispatch_source_cancel(_timer);
        _timer = nil;
        self.state = YMGCDTimerStateStop;
    }
    
    [self.lock unlock];
}

@end
