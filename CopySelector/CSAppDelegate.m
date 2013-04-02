//
//  CSAppDelegate.m
//  CopySelector
//
//  Created by Andy Lee on 4/2/13.
//  Copyright (c) 2013 Andy Lee. All rights reserved.
//

#import "CSAppDelegate.h"
#import "CSServicesProvider.h"

@implementation CSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [NSApp setServicesProvider:[[[CSServicesProvider alloc] init] autorelease]];
    NSUpdateDynamicServices();
}

@end
