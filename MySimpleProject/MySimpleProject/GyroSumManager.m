//
//  GyroSumManager.m
//  MySimpleProject
//

#import <Foundation/Foundation.h>

#import "GyroSumManager.h"
#import <KotlinNativeFramework/KotlinNativeFramework.h>
#import <CoreMotion/CoreMotion.h>

@interface GyroSumManager()



@property (nonatomic, readonly, strong) KNFKotlinNativeFramework *knf;

@property (nonatomic, strong, readonly) CMMotionManager *motionManager;

@property (nonatomic, strong, readonly) NSOperationQueue *sensorQueue;

@end

@implementation GyroSumManager

-(instancetype)init
{
    if (self = [super init]) {
        _knf = [KNFKotlinNativeFramework new];

        _motionManager = [[CMMotionManager alloc] init];
        
        _sensorQueue = [NSOperationQueue new];
        self.sensorQueue.name = @"SensorDataQueue";
        self.sensorQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)start {
    __block __weak typeof(self) weakSelf = self;

    [self.motionManager startGyroUpdatesToQueue:self.sensorQueue withHandler:^(CMGyroData *gyroData, NSError *error) {
        if (gyroData != nil) {
            KNFInputData *input = [[KNFInputData alloc] initWithX:gyroData.rotationRate.x];
            KNFOutputData *output = [weakSelf.knf performOperationInput:input];
            NSLog(@"output = %@", output);
        }
    }];
}


@end
