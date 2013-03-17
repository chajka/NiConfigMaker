//
//  NiConfigMaker.m
//  NiConfigMaker
//
//  Created by Чайка on 3/16/13.
//  Copyright (c) 2013 Instrumentality of mankind. All rights reserved.
//

#import <QTKit/QTKit.h>
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
	{		// correct input devices
		audioDevices = [QTCaptureDevice inputDevicesWithMediaType:QTMediaTypeSound];
		videoDevides = [QTCaptureDevice inputDevicesWithMediaType:QTMediaTypeVideo];
	}// end if

	return self;
}// end - (id) init

- (void) dealloc
{
    [super dealloc];
}// dealloc

- (void) awakeFromNib
{			// assign input devices into own popup menu
		// audio devices
	[popupFMLEAudioInputDevice removeAllItems];
	for (QTCaptureDevice *device in audioDevices)
	{
		[popupFMLEAudioInputDevice addItemWithTitle:[device localizedDisplayName]];
	}// end foreach FMLE input audio devices

		// video devices
	[popupFMLEVideoInputDeviceName removeAllItems];
	for (QTCaptureDevice *device in videoDevides)
	{
		[popupFMLEVideoInputDeviceName addItemWithTitle:[device localizedDisplayName]];
	}// end foreach FMLE input video devices
}// end - (void) awakeFromNib

- (void) applicationDidFinishLaunching:(NSNotification *)notification
{
	// Insert code here to initialize your application
}// end - (void) applicationDidFinishLaunching:(NSNotification *)notification

#pragma mark - actions
- (IBAction) fmleSampleRateSelected:(NSPopUpButton *)sender
{
}// end - (IBAction) fmleSampleRateSelected:(NSPopUpButton *)sender

- (IBAction) fmleFrameRateSelected:(NSPopUpButton *)sender
{
}// end - (IBAction) fmleFrameRateSelected:(NSPopUpButton *)sender

- (IBAction) fmleInputSizeSelected:(NSPopUpButton *)sender
{
	NSMenuItem *fmleInputSizeItem = [sender selectedItem];
	VideoSize selectedVideoSizeTag = [fmleInputSizeItem tag];
	NSMenuItem *camTwistMenuItem = [[popupCamTwistVideoSize menu] itemWithTag:selectedVideoSizeTag];
	
	if (camTwistMenuItem != nil)
	{
		[popupCamTwistVideoSize selectItemWithTag:selectedVideoSizeTag];
		self.camTwistCustomVideoSize = NO;
		return;
	}// end if CamTwist video size menu have fmle selected video size

		// selected video size is not found in CamTwistMenu
	NSString *selectedSizeString = [fmleInputSizeItem title];
	NSArray *inputSizes = [selectedSizeString componentsSeparatedByString:VideoSizeSeparatorString];
	[txtfldCamTwistCustomX setStringValue:[inputSizes objectAtIndex:0]];
	[txtfldCamTwistCustomY setStringValue:[inputSizes lastObject]];
	
	self.camTwistCustomVideoSize = YES;
}// end - (IBAction) fmleInputSizeSelected:(NSPopUpButton *)sender

- (IBAction) camTwistVideoSizeSelected:(NSPopUpButton *)sender
{
}// end - (IBAction) camTwistVideoSizeSelected:(NSPopUpButton *)sender

- (IBAction) camTwistSaveConfig:(NSButton *)sender
{
}// end - (IBAction) camTwistSaveConfig:(NSButton *)sender
@end
