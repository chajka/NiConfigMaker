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
- (NSArray *) collectFMLEConfgurations;
@end

@implementation NiConfigMaker
@synthesize adjustBitrate;
@synthesize syncFrameRate;
@synthesize syncVideoSize;
@synthesize camTwistCustomVideoSize;
@synthesize fmleAudioOutputFormat;
@synthesize nellyMoserSelected;
@synthesize h264Selected;
@synthesize fmleVideoOutputFormat;
@synthesize aacSelected;

- (id) init
{
	self = [super init];
	if (self)
	{		// correct input devices
		audioDevices = [QTCaptureDevice inputDevicesWithMediaType:QTMediaTypeSound];
		videoDevides = [QTCaptureDevice inputDevicesWithMediaType:QTMediaTypeVideo];
		fmleConfigurations = [self collectFMLEConfgurations];
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

		// fmle profiles
	[popupFMLEProfileNames removeAllItems];
	[popupFMLEProfileNames addItemsWithTitles:fmleConfigurations];
}// end - (void) awakeFromNib

- (void) applicationDidFinishLaunching:(NSNotification *)notification
{
	// Insert code here to initialize your application
	[drawerEncoderSettings toggle:self];
}// end - (void) applicationDidFinishLaunching:(NSNotification *)notification

#pragma mark - actions
- (IBAction) fmleSampleRateSelected:(NSPopUpButton *)sender
{
}// end - (IBAction) fmleSampleRateSelected:(NSPopUpButton *)sender

- (IBAction) fmleFrameRateSelected:(NSPopUpButton *)sender
{
}// end - (IBAction) fmleFrameRateSelected:(NSPopUpButton *)sender

- (IBAction) fmleEncodingFormatSelected:(NSPopUpButton *)sender
{
	[popupFMLEAudioOutputFormat selectItemWithTag:KindMP3];
	switch (fmleVideoOutputFormat) {
		case KindH264:
			self.h264Selected = YES;
			break;
		case KindVP6:
		default:
			self.h264Selected = NO;
			break;
	}// end case by Video output format
}// end - (IBAction) fmleEncodingFormatSelected:(NSPopUpButton *)sender

- (IBAction) fmleInputSizeSelected:(NSPopUpButton *)sender
{
	NSMenuItem *fmleInputSizeItem = [sender selectedItem];
	VideoSize selectedVideoSizeTag = [fmleInputSizeItem tag];
	NSMenuItem *camTwistMenuItem = [[popupCamTwistVideoSize menu] itemWithTag:selectedVideoSizeTag];

	NSString *selectedSizeString = [fmleInputSizeItem title];
	NSArray *inputSizes = [selectedSizeString componentsSeparatedByString:VideoSizeSeparatorString];
	NSString *videoSizeWidth = [inputSizes objectAtIndex:0];
	NSString *videoSizeHeight = [inputSizes lastObject];
	[txtfldFMLEVideoOutputSizeX setStringValue:videoSizeWidth];
	[txtfldFMLEVideoOutputSizeY setStringValue:videoSizeHeight];
	
	if (camTwistMenuItem != nil)
	{
		[popupCamTwistVideoSize selectItemWithTag:selectedVideoSizeTag];
		self.camTwistCustomVideoSize = NO;
		return;
	}// end if CamTwist video size menu have fmle selected video size

		// selected video size is not found in CamTwistMenu
	[txtfldCamTwistCustomX setStringValue:videoSizeWidth];
	[txtfldCamTwistCustomY setStringValue:videoSizeHeight];
	
	self.camTwistCustomVideoSize = YES;
}// end - (IBAction) fmleInputSizeSelected:(NSPopUpButton *)sender

- (IBAction) camTwistVideoSizeSelected:(NSPopUpButton *)sender
{
}// end - (IBAction) camTwistVideoSizeSelected:(NSPopUpButton *)sender

- (IBAction) camTwistSaveConfig:(NSButton *)sender
{
}// end - (IBAction) camTwistSaveConfig:(NSButton *)sender

#pragma mark - private
- (NSArray *) collectFMLEConfgurations
{
	NSError *err = nil;
	NSFileManager *fm = [NSFileManager defaultManager];
		// create path string
	NSString *fmleProfileFolderPath = [FMLESettingPath stringByExpandingTildeInPath];
		// check path is directory
	BOOL isDir = NO;
	BOOL exists = [fm fileExistsAtPath:fmleProfileFolderPath isDirectory:&isDir];
	if ((exists == NO) || (isDir == NO))
		return nil;

		// get profiles in profile directory
	NSArray *profiles = [fm contentsOfDirectoryAtPath:fmleProfileFolderPath error:&err];
	if ((profiles == nil) || (err != nil))
		return nil;

		// make array of profile names
	NSMutableArray *profileNames = [NSMutableArray array];
	NSString *profileName = nil;
	for (NSString *profile in profiles)
	{
		profileName = [[profile lastPathComponent] stringByDeletingPathExtension];
		[profileNames addObject:profileName];
		profileName = nil;
	}// end foreach profiles

	return ([profileNames count] != 0) ? [NSArray arrayWithArray:profileNames] : nil;
}// end - (NSArray *) collectFMLEConfgurations
@end
