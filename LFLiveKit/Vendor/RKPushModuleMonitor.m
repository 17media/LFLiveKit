//
//  RKPushModuleMonitor.m
//  LFLiveKit
//
//  Created by Jan Chen on 2019/8/13.
//

#import "RKPushModuleMonitor.h"

static CGFloat const RKDefaultFrameConsumptionStoppedThreshold = 5.0f;
static CGFloat const RKDefaultVideoEncoderMalfunctionThreshold = 5.0f;


@interface RKPushModuleMonitor()

@property (nonatomic, strong) NSDate *latestVideoEncodeDate;
@property (nonatomic, strong) NSDate *latestFrameConsumptionDate;
@property (nonatomic, assign) BOOL isVideoEcndoeMalfunction;
@property (nonatomic, assign) BOOL isFrameConsumptionStopped;

@end

@implementation RKPushModuleMonitor

#pragma mark - Public Methods

- (void)startMonitor {
    [self keepMonitor];
}

- (void)updateVideoEncodeDate {
    self.latestVideoEncodeDate = [NSDate date];
}

- (void)updateFrameConsumptionDate {
    self.latestFrameConsumptionDate = [NSDate date];
}

#pragma mark -- Accesor

- (void)setIsFrameConsumptionStopped:(BOOL)isFrameConsumptionStopped {
    if (_isFrameConsumptionStopped != isFrameConsumptionStopped) {
        _isFrameConsumptionStopped = isFrameConsumptionStopped;
        if ([self.delegate respondsToSelector:@selector(pushModuleMonitor:isFrameConsumptionStopped:)]) {
            [self.delegate pushModuleMonitor:self isFrameConsumptionStopped:isFrameConsumptionStopped];
        }
    }
}

- (void)setIsVideoEcndoeMalfunction:(BOOL)isVideoEcndoeMalfunction {
    if (_isVideoEcndoeMalfunction != isVideoEcndoeMalfunction) {
        _isVideoEcndoeMalfunction = isVideoEcndoeMalfunction;
        if ([self.delegate respondsToSelector:@selector(pushModuleMonitor:isVideoEcndoeMalfunction:)]) {
            [self.delegate pushModuleMonitor:self isVideoEcndoeMalfunction:isVideoEcndoeMalfunction];
        }
    }
}

#pragma mark - Private Methods

- (void)keepMonitor {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf check];
        [weakSelf keepMonitor];
    });
}

- (void)check {
    NSDate *now = [NSDate date];
    // check videoEncoder 是否正常執行
    if (self.latestVideoEncodeDate) {
        NSTimeInterval videoEncodeDiff = [now timeIntervalSinceDate:self.latestVideoEncodeDate];
        self.isVideoEcndoeMalfunction = videoEncodeDiff > RKDefaultVideoEncoderMalfunctionThreshold;
        NSLog(@"[SEL] videoEncodeDiff: %f", videoEncodeDiff);
    }
    
    // check LFStreamingBuffer 是否正常被消耗
    if (self.latestFrameConsumptionDate) {
        NSTimeInterval frameConsumptionDiff = [now timeIntervalSinceDate:self.latestFrameConsumptionDate];
        self.isFrameConsumptionStopped = frameConsumptionDiff > RKDefaultFrameConsumptionStoppedThreshold;
        NSLog(@"[SEL] frameConsumptionDiff: %f", frameConsumptionDiff);
    }
}


@end
