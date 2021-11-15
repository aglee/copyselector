//
//  main.m
//  CopySelector
//
//  Created by Andy Lee on 4/2/13.
//  Copyright (c) 2013 Andy Lee. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "CSServicesProvider.h"

int main(int argc, char *argv[])
{
	@autoreleasepool {
		CSServicesProvider *service = [[CSServicesProvider alloc] init];
		
		NSRegisterServicesProvider(service, @"CopySelector");
		
		[[NSRunLoop currentRunLoop] run];
	}
	
	return 0;
}
