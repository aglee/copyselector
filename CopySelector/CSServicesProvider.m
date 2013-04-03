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

// "copySelector" is what appears in Info.plist. The rest of the method name is implied.
- (void)copySelector:(NSPasteboard *)pboard
            userData:(NSString *)userData
               error:(NSString **)errorMessagePtr
{
    // Make sure the pasteboard contains a string.
    if (![pboard canReadObjectForClasses:@[[NSString class]] options:@{}])
    {
        *errorMessagePtr = NSLocalizedString(@"Error: the pasteboard doesn't contain a string.", nil);
        return;
    }

    // Try to parse a selector from the pasteboard contents.
    NSString *pasteboardString = [pboard stringForType:NSPasteboardTypeString];
    NSString *methodName = [AKMethodNameExtractor extractMethodNameFromString:pasteboardString];

    if (methodName == nil)
    {
        NSBeep();
        return;
    }

    // Stuff the extracted method name into the system paste buffer.
    NSPasteboard *generalPasteboard = [NSPasteboard generalPasteboard];
    
    [generalPasteboard declareTypes:@[NSStringPboardType] owner:nil];
    [generalPasteboard setString:methodName forType:NSStringPboardType];
}

@end
