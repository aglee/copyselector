//
//  CSServicesProvider.m
//  CopySelector
//
//  Created by Andy Lee on 4/2/2013
//  Copyright (c) 2013 Andy Lee. All rights reserved.
//

#import "CSServicesProvider.h"

#import "AKMethodNameExtractor.h"

@implementation CSServicesProvider

#pragma mark -
#pragma mark Methods listed in the NSServices section of Info.plist

// "copyWithSelectorAwareness" is what appears in Info.plist. The rest of the
// method name is implied.
- (void)copyWithSelectorAwareness:(NSPasteboard *)pboard
                         userData:(NSString *)userData
                            error:(NSString **)errorMessagePtr
{
    // Make sure the pasteboard contains a string.
    if (![pboard canReadObjectForClasses:@[[NSString class]] options:@{}])
    {
        *errorMessagePtr = NSLocalizedString(@"Error: the pasteboard doesn't contain a string.", nil);
        return;
    }

    // Get the string from the pasteboard.
    NSString *pasteboardString = [pboard stringForType:NSPasteboardTypeString];
    NSString *methodName = [AKMethodNameExtractor extractMethodNameFromString:pasteboardString];

    if (methodName)
    {
        pasteboardString = methodName;
    }

    // Stuff the extracted method name, or the original string if none, into the
    // system-wide copy/paste pasteboard.
    NSPasteboard *generalPasteboard = [NSPasteboard generalPasteboard];
    
    [generalPasteboard declareTypes:@[NSStringPboardType] owner:nil];
    [generalPasteboard setString:pasteboardString forType:NSStringPboardType];

    // Hide the app.
    [NSApp performSelector:@selector(hide:) withObject:nil afterDelay:0];
}

@end
