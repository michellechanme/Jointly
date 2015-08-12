//
//  ScreenLockObserver.h
//  Jointly
//
//  Created by Michelle Chan on 8/12/15.
//  Copyright (c) 2015 Michelle Chan. All rights reserved.
//

@import Foundation;

@interface ScreenLockObserver : NSObject

+ (instancetype)sharedObserver;

- (void)applicationDidFinishLaunching;
- (void)applicationWillEnterForeground;

- (BOOL)didEnterBackgroundDueToLockButtonPress;

@end
