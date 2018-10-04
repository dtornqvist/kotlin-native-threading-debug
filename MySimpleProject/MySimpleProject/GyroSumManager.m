//
//  GyroSumManager.m
//  MySimpleProject
//

#import <Foundation/Foundation.h>

#import "GyroSumManager.h"
#import "SingleThreadWorker.h"
#import <CoreMotion/CoreMotion.h>

@interface GyroSumManager()

@property (nonatomic, strong, readonly) CMMotionManager *motionManager;
@property (nonatomic, strong, readonly) NSOperationQueue *sensorQueue;
@property (nonatomic, strong, readonly) SingleThreadWorker *worker;
@property (nonatomic, strong) KNFGyroSumComputer *gyroSumComputer;

@end

@implementation GyroSumManager

-(instancetype)init
{
    if (self = [super init]) {
        _motionManager = [[CMMotionManager alloc] init];
        
        _worker = [SingleThreadWorker new];

        _sensorQueue = [NSOperationQueue new];
        self.sensorQueue.name = @"SensorDataQueue";
        self.sensorQueue.maxConcurrentOperationCount = 1;

    }
    return self;
}

- (void)start
{
    NSLog(@"GyroSumManager start");
    [self.worker start];
    
    __block __weak typeof(self) weakSelf = self;
    
    [self.worker addBlock:^(void) {
        weakSelf.gyroSumComputer = [KNFGyroSumComputer new];
    }];
    
    [self.motionManager startGyroUpdatesToQueue:self.sensorQueue withHandler:^(CMGyroData *gyroData, NSError *error) {
        if (gyroData != nil) {
            [weakSelf.worker addBlock:^() {
                KNFInputData *input = [[KNFInputData alloc] initWithX:gyroData.rotationRate.x];
                KNFOutputData *outputData = [weakSelf.gyroSumComputer performOperationInput:input];
                NSLog(@"%@", outputData);
            }];
        }
    }];
}

-(void)gyroSumUpdateOutputData:(KNFOutputData *)outputData
{
    NSLog(@"%@", outputData);
}


@end
