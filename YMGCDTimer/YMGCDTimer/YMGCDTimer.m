//
//  YMGCDTimer.m
//  emptyPro
//
//  Created by yuman01 on 2019/7/18.
//  Copyright © 2019 yuman. All rights reserved.
//

#import "YMGCDTimer.h"

static const NSTimeInterval EPS = 0.001;

@interface YMGCDTimer ()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation YMGCDTimer

+ (YMGCDTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(dispatch_block_t)block
{
    if (isnan(interval) || isinf(interval) || interval <= EPS || !block) {
        return nil;
    }
    return [[YMGCDTimer alloc] initWithTimeInterval:interval repeats:repeats block:block];
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(dispatch_block_t)block
{
    self = [super init];
    if (self) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            if (block) {
                block();
            }
            if (!repeats) {
                dispatch_source_cancel(self->_timer);
            }
        });
        dispatch_resume(_timer);
    }
    return self;
}

- (void)invalidate
{
    dispatch_source_cancel(_timer);
}

- (void)dealloc
{
    dispatch_source_cancel(_timer);
}

@end
