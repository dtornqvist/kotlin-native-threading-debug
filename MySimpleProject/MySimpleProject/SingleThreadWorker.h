//
//  SingleThreadWorker.h
//  MySimpleProject
//
//

#import <Foundation/Foundation.h>
#import <KotlinNativeFramework/KotlinNativeFramework.h>

@interface SingleThreadWorker : NSObject

- (void)start;
- (void)stop;
- (void)addBlock:(void (^)(void))block;

@end
