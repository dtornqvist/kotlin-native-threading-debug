//
//  SingleThreadWorker.m
//  MySimpleProject
//
//

#import "SingleThreadWorker.h"

@interface SingleThreadWorker()

@property (nonatomic, strong) NSThread *thread;
@property (nonatomic) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) NSMutableArray *blockArray;

@end

@implementation SingleThreadWorker

- (instancetype)init
{
    if (self = [super init]) {
        _semaphore = dispatch_semaphore_create(0);
        _blockArray = [NSMutableArray new];
    }
    return self;
}

#pragma mark - Private

- (NSThread*)thread
{
    if (!_thread) {
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(runloop) object:nil];
    }
    return _thread;
}

- (void)runloop
{
    @autoreleasepool {
        // Init
        
        // Loop
        while (![self.thread isCancelled]) {
            
            void (^block)(void) = nil;
            @synchronized (self) {
                if ([self.blockArray count] > 0) {
                    block = [self.blockArray firstObject];
                    [self.blockArray removeObjectAtIndex:0];
                }
            }
            
            if (block != nil) {
                block();
            } else {
                dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
            }
        }
        
        // De-init
        self.thread = nil;
    }
}

#pragma mark - Public

- (void)start
{
    if (![self.thread isExecuting]) {
        [self.thread start];
    }
}

- (void)stop
{
    if ([self.thread isExecuting]) {
        [self.thread cancel];
    }
}

- (void)addBlock:(void (^)(void))block
{
    @synchronized (self) {
        [self.blockArray addObject:block];
        if ([self.blockArray count] == 1) {
            dispatch_semaphore_signal(self.semaphore);
        }
    }
}

@end
