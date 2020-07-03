//
//  YMGCDTimer.h
//  
//
//  Created by yuman on 2019/7/18.
//  Copyright © 2019 yuman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMGCDTimer : NSObject

/**
 生成一个YMGCDTimer
 该timer需要手动启动
 该timer释放时自动停止
 该timer支持暂停/恢复
 该timer支持多线程操作
 注意：「暂停」行为会影响当次计时的精确性
 假设触发间隔为A，在某次计时中暂停了B秒，那么本次触发间隔不是恰好的(A+B)，而是会约有正负几十到几百毫秒的误差
 这个问题是iOS的固有bug，但只影响有暂停行为的计时次，全程无暂停的计时次都是精确的

 @param interval 触发间隔时间，单位是秒
 @param repeats 是否重复触发
 @param block 触发时执行的操作；count为第几次触发(从0计数)；该block一定在「主线程」执行
 @return 如果创建成功，则返回一个YMGCDTimer，否则返回nil
 */
+ (YMGCDTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void(^)(NSUInteger count))block;

/// 启动计时器
/// 对于新建或暂停的计时器，调用此方法进入计时
- (void)start;

/// 暂停计时器
/// 对于正在计时的计时器，调用此方法暂停计时
- (void)pause;

/// 停止计时器
/// 计时器被释放时会自动停止，亦可手动调用此方法停止
/// 被停止的计时器无法恢复，调用start/pause方法将无效
- (void)stop;

@end
