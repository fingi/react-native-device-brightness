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

-(void) brightnessDidChange:(NSNotification*)notification
{
    NSLog(@"Brightness did change");
    [self.bridge.eventDispatcher sendAppEventWithName:@"BrightnessChanged" body:@{@"brightness":@([UIScreen mainScreen].brightness)}];
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
