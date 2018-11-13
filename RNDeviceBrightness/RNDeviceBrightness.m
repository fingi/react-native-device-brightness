//
//  RNDeviceBrightness.m
//  RNDeviceBrightness
//
//  Created by Calvin on 3/11/17.
//  Copyright © 2017 CapsLock. All rights reserved.
//

#import "RNDeviceBrightness.h"
#import "RCTEventDispatcher.h"

@implementation RNDeviceBrightness

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

- (instancetype)init
{
    if ((self = [super init])) {
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(brightnessDidChange:) name:UIScreenBrightnessDidChangeNotification object:nil];
    }
    return self;
}


dispatch_source_t CreateDebounceDispatchTimer(double debounceTime, dispatch_queue_t queue, dispatch_block_t block) {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

    if (timer) {
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, debounceTime * NSEC_PER_SEC), DISPATCH_TIME_FOREVER, (1ull * NSEC_PER_SEC) / 10);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }

    return timer;
}

- (void)doSomethingRepeatedlyThatShouldBeLimited {
    if (self.debounceTimer != nil) {
        dispatch_source_cancel(self.debounceTimer);
        self.debounceTimer = nil;
    }

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    double secondsToThrottle = 1.000f;
    self.debounceTimer = CreateDebounceDispatchTimer(secondsToThrottle, queue, ^{
        NSLog(@"Brightness did change");
        [self.bridge.eventDispatcher sendAppEventWithName:@"BrightnessChanged" body:@{@"brightness":@([UIScreen mainScreen].brightness)}];
    });
}

-(void) brightnessDidChange:(NSNotification*)notification
{
      [self doSomethingRepeatedlyThatShouldBeLimited];
   // [self.bridge.eventDispatcher sendAppEventWithName:@"BrightnessChanged" body:@{@"brightness":@([UIScreen mainScreen].brightness)}];
}

RCT_EXPORT_METHOD(setBrightnessLevel:(float)brightnessLevel)
{
    [UIScreen mainScreen].brightness = brightnessLevel;
}

RCT_REMAP_METHOD(getBrightnessLevel,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    resolve(@([UIScreen mainScreen].brightness));
}

@end
