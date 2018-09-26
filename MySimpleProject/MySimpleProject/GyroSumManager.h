//
//  GyroSumManager.h
//  MySimpleProject
//

#import <Foundation/Foundation.h>
#import <KotlinNativeFramework/KotlinNativeFramework.h>

@interface GyroSumManager : NSObject <KNFGyroSumWorkerListener>

- (void)start;

@end
