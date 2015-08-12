//
//  ScreenLockObserver.m
//  Jointly
//
//  Created by Michelle Chan on 8/12/15.
//  Copyright (c) 2015 Michelle Chan. All rights reserved.
//

#import "ScreenLockObserver.h"

static void displayStatusChanged(CFNotificationCenterRef center,
                                 void *observer,
                                 CFStringRef name,
                                 const void *object,
                                 CFDictionaryRef userInfo);

@implementation ScreenLockObserver

+ (instancetype)sharedObserver {
    static ScreenLockObserver *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ScreenLockObserver alloc] init];
    });
    
    return sharedInstance;
}

- (void)registerForScreenLockNotification {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    displayStatusChanged,
                                    CFSTR("com.apple.springboard.lockcomplete"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
}

- (void)applicationDidFinishLaunching {
    [self registerForScreenLockNotification];
}

- (void)applicationWillEnterForeground {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisplayStatusLocked"];
}

- (BOOL)didEnterBackgroundDueToLockButtonPress {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisplayStatusLocked"];
}

@end

static void displayStatusChanged(CFNotificationCenterRef center,
                                 void *observer,
                                 CFStringRef name,
                                 const void *object,
                                 CFDictionaryRef userInfo) {
    if (name == CFSTR("com.apple.springboard.lockcomplete")) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisplayStatusLocked"];
    }
}
