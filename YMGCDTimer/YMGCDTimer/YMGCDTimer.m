//
//  YMGCDTimer.m
//  
//
//  Created by yuman on 2019/7/18.
//  Copyright © 2019 yuman. All rights reserved.
//

#import "YMGCDTimer.h"

#define LOCK(lock) do{ dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER); }while(0)
#define UNLOCK(lock) do{ dispatch_semaphore_signal(lock); }while(0)

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
@property (nonatomic, strong) dispatch_semaphore_t lock;

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
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        _interval = interval;
        _state = YMGCDTimerStateInit;
        _lock = dispatch_semaphore_create(1);
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(_timer, ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            if (!repeats) {
                [strongSelf stop];
            }
            if (block) {
                block(strongSelf->_count++);
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
    LOCK(self.lock);
    
    if (self.state == YMGCDTimerStateInit) {
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, _interval * NSEC_PER_SEC), _interval * NSEC_PER_SEC, 0);
        dispatch_resume(_timer);
        self.state = YMGCDTimerStateRunning;
        UNLOCK(self.lock);
        return;
    }
    
    if (self.state == YMGCDTimerStatePause) {
        dispatch_resume(_timer);
        self.state = YMGCDTimerStateRunning;
    }
    
    UNLOCK(self.lock);
}

- (void)pause
{
    LOCK(self.lock);
    
    if (self.state == YMGCDTimerStateRunning) {
        dispatch_suspend(_timer);
        self.state = YMGCDTimerStatePause;
    }
    
    UNLOCK(self.lock);
}

- (void)autoStartOrPause
{
    LOCK(self.lock);
    YMGCDTimerState state = self.state;
    UNLOCK(self.lock);
    
    if ((state == YMGCDTimerStateInit) || (state == YMGCDTimerStatePause)) {
        [self start];
    } else if (state == YMGCDTimerStateRunning) {
        [self pause];
    }
}

- (void)stop
{
    LOCK(self.lock);
    
    if (self.state != YMGCDTimerStateStop) {
        if (self.state != YMGCDTimerStateRunning) {
            dispatch_resume(_timer);
        }
        dispatch_source_cancel(_timer);
        _timer = nil;
        self.state = YMGCDTimerStateStop;
    }
    
    UNLOCK(self.lock);
}

- (BOOL)isRunning
{
    LOCK(self.lock);
    YMGCDTimerState state = self.state;
    UNLOCK(self.lock);
    return (state == YMGCDTimerStateRunning);
}

@end
