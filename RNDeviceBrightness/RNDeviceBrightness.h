//
//  RNDeviceBrightness.h
//  RNDeviceBrightness
//
//  Created by Calvin on 3/11/17.
//  Copyright © 2017 CapsLock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTBridgeModule.h"

@interface RNDeviceBrightness : NSObject <RCTBridgeModule>
@property(strong) dispatch_source_t debounceTimer;
@end
