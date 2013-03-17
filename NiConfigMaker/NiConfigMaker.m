//
//  NiConfigMaker.m
//  NiConfigMaker
//
//  Created by Чайка on 3/16/13.
//  Copyright (c) 2013 Instrumentality of mankind. All rights reserved.
//

#import "NiConfigMaker.h"

@interface NiConfigMaker ()

@end

@implementation NiConfigMaker
@synthesize adjustBitrate;
@synthesize syncFrameRate;
@synthesize syncVideoSize;
@synthesize camTwistCustomVideoSize;

- (id) init
{
	self = [super init];
	if (self)
	{
		
	}// end if

	return self;
}// end - (id) init

- (void) dealloc
{
    [super dealloc];
}// dealloc

- (void) awakeFromNib
{
	
}// end - (void) awakeFromNib

- (void) applicationDidFinishLaunching:(NSNotification *)notification
{
	// Insert code here to initialize your application
}// end - (void) applicationDidFinishLaunching:(NSNotification *)notification

@end
