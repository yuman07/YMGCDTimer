//
//  YMGCDTimer.h
//  emptyPro
//
//  Created by yuman01 on 2019/7/18.
//  Copyright © 2019 yuman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMGCDTimer : NSObject

+ (YMGCDTimer *)timerWithTimeInterval:(NSTimeInterval)interval
                              repeats:(BOOL)repeats
                       runInMainQueue:(BOOL)runInMainQueue
                                block:(dispatch_block_t)block;

- (void)invalidate;

@end
