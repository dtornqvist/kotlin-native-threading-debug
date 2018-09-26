//
//  GyroSumManager.m
//  MySimpleProject
//

#import <Foundation/Foundation.h>

#import "GyroSumManager.h"
#import <CoreMotion/CoreMotion.h>

@interface GyroSumManager()

@property (nonatomic, readonly, strong) KNFGyroSumWorker *gyroSumWorker;
@property (nonatomic, strong, readonly) CMMotionManager *motionManager;

@end

@implementation GyroSumManager

-(instancetype)init
{
    if (self = [super init]) {
        _gyroSumWorker = [KNFGyroSumWorker new];
        self.gyroSumWorker.listener = self;

        _motionManager = [[CMMotionManager alloc] init];
    }
    return self;
}

- (void)start
{
    __block __weak typeof(self) weakSelf = self;

    [self.motionManager startGyroUpdatesToQueue:NSOperationQueue.mainQueue withHandler:^(CMGyroData *gyroData, NSError *error) {
        if (gyroData != nil) {
            KNFInputData *input = [[KNFInputData alloc] initWithX:gyroData.rotationRate.x];
            [weakSelf.gyroSumWorker performOperationInput:input];
        }
    }];
}

-(void)gyroSumUpdateOutputData:(KNFOutputData *)outputData
{
    NSLog(@"%@", outputData);
}


@end
