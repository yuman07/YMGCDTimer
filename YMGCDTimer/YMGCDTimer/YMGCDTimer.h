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
 该timer释放时自动停止
 该timer支持暂停/恢复
 该timer支持多线程操作

 @param interval 触发间隔，单位是秒，必须大于0
 @param repeats 是否重复触发
 @param block 触发时执行的操作；count为触发计数(从0开始)；该block将在「主线程」执行
 @return 如果创建成功，则返回一个YMGCDTimer实例，否则返回nil
 */
+ (YMGCDTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void(^)(NSUInteger count))block;

/// 启动计时器
/// 对于新建或暂停中的计时器，调用此方法进入计时
- (void)start;

/// 暂停计时器
/// 对于计时中的计时器，调用此方法暂停计时
- (void)pause;

/// 停止计时器
/// 计时器被释放时会自动停止，亦可手动调用此方法停止
/// 被停止的计时器无法恢复，调用start/pause方法将无效
- (void)stop;

@end
