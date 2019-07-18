//
//  YMGCDTimer.h
//  emptyPro
//
//  Created by yuman01 on 2019/7/18.
//  Copyright © 2019 yuman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMGCDTimer : NSObject

/**
 生成一个GCDTimer，并立即启动

 @param interval 计时器触发间隔时间，单位是秒
 @param repeats 是否重复触发
 @param block 触发时执行的操作，在'子'线程执行
 @return 如果创建成功，则返回一个YMGCDTimer并立即启动。否则返回nil
 */
+ (YMGCDTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(dispatch_block_t)block;

/**
 手动停止一个timer
 */
- (void)invalidate;

@end
