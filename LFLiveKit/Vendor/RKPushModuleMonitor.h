//
//  RKPushModuleMonitor.h
//  LFLiveKit
//
//  Created by Jan Chen on 2019/8/13.
//

#import <Foundation/Foundation.h>

@class RKPushModuleMonitor;

@protocol RKPushModuleMonitorDelegate <NSObject>

@optional

- (void)pushModuleMonitor:(nullable RKPushModuleMonitor *)pushModuleMonitor isFrameConsumptionStopped:(BOOL)isFrameConsumptionStopped;
- (void)pushModuleMonitor:(nullable RKPushModuleMonitor *)pushModuleMonitor isVideoEcndoeMalfunction:(BOOL)isVideoEcndoeMalfunction;

@end

@interface RKPushModuleMonitor : NSObject

@property (nullable, weak, nonatomic) id<RKPushModuleMonitorDelegate> delegate;

- (void)updateVideoEncodeDate;
- (void)updateFrameConsumptionDate;
- (void)startMonitor;

@end

