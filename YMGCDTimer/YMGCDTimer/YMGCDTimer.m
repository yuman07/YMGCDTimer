//
//  YMGCDTimer.m
//  
//
//  Created by yuman on 2019/7/18.
//  Copyright © 2019 yuman. All rights reserved.
//

#import "YMGCDTimer.h"

@interface YMGCDTimer ()

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSUInteger count;

@end

@implementation YMGCDTimer

+ (YMGCDTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void(^)(NSUInteger count))block
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
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(_timer, ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            if (block) {
                block(strongSelf->_count++);
            }
            if (!repeats) {
                dispatch_source_cancel(strongSelf.timer);
            }
        });
        dispatch_resume(_timer);
    }
    return self;
}

- (void)dealloc
{
    dispatch_source_cancel(_timer);
}

@end
