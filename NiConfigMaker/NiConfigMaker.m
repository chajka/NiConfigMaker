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
- (void) loadFMLEProfile:(NSString *)profile;
- (NSString *) valueForXPath:(NSString *)xPath from:(NSXMLElement *)element;
@end

@implementation NiConfigMaker
@synthesize adjustBitrate;
@synthesize syncFrameRate;
@synthesize syncVideoSize;
@synthesize camTwistCustomVideoSize;
@synthesize fmleAudioOutputFormat;
@synthesize nellyMoserSelected;
@synthesize h264Selected;
@synthesize inputVolume;
@synthesize preserveAspect;
@synthesize fmleVideoOutputFormat;
@synthesize aacSelected;

- (id) init
{
	self = [super init];
	if (self)
	{		// correct input devices
		audioDevices = [QTCaptureDevice inputDevicesWithMediaType:QTMediaTypeSound];
		videoDevides = [QTCaptureDevice inputDevicesWithMediaType:QTMediaTypeVideo];
		fmleProfiles = [self collectFMLEConfgurations];
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
	[[[popupFMLEAudioInputDevice menu] itemAtIndex:0] setState:NSOnState];

		// video devices
	[popupFMLEVideoInputDeviceName removeAllItems];
	for (QTCaptureDevice *device in videoDevides)
	{
		[popupFMLEVideoInputDeviceName addItemWithTitle:[device localizedDisplayName]];
	}// end foreach FMLE input video devices
	[[[popupFMLEVideoInputDeviceName  menu] itemAtIndex:0] setState:NSOnState];

		// fmle profiles
	[popupFMLEProfileNames removeAllItems];
	[popupFMLEProfileNames addItemsWithTitles:fmleProfiles];
	[[[popupFMLEProfileNames  menu] itemAtIndex:0] setState:NSOnState];
}// end - (void) awakeFromNib

- (void) applicationDidFinishLaunching:(NSNotification *)notification
{
		// load startup state
	[self loadFMLEProfile:FMLEDefalutProfileName];
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
	fmleProfilePath = [[NSString alloc] initWithString:[FMLEProfilePath stringByExpandingTildeInPath]];
		// check path is directory
	BOOL isDir = NO;
	BOOL exists = [fm fileExistsAtPath:fmleProfilePath isDirectory:&isDir];
	if ((exists == NO) || (isDir == NO))
		return nil;

		// get profiles in profile directory
	NSArray *profiles = [fm contentsOfDirectoryAtPath:fmleProfilePath error:&err];
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

- (void) loadFMLEProfile:(NSString *)profile
{
		// load profile
	NSError *err = nil;
	NSString *profilePath = [fmleProfilePath stringByAppendingPathComponent:profile];
	profilePath = [profilePath stringByAppendingPathExtension:FMLEProfileExtension];
	NSData *profileData = [NSData dataWithContentsOfFile:profilePath];
	currentFMLEProfile = [[NSXMLDocument alloc] initWithData:profileData options:NSXMLDocumentTidyXML error:&err];

		// parse and set to panel
	NSString *item = nil;
	NSInteger index = 0;
	NSXMLElement *root = [currentFMLEProfile rootElement];

			// capture
		// inut video device
	item = [self valueForXPath:FMLEVideoDeviceXPath from:root];
	index = [popupFMLEVideoInputDeviceName indexOfItemWithTitle:item];
	[popupFMLEVideoInputDeviceName selectItemAtIndex:index];
		// input video framerate
	item = [self valueForXPath:FMLEVideoFrameRateXPath from:root];
	[popupFMLEVideoFramerate selectItemWithTitle:item];
		// input video width
	NSString *width = [self valueForXPath:FMLEVideoFrameWidthXPath from:root];
	NSString *height = [self valueForXPath:FMLEVideoFrameHeightXPath from:root];
	item = [NSString stringWithFormat:VideoSizeConstructFormat, width, height];
	[popupFMLEVideoInputSize selectItemWithTitle:item];
	[self fmleInputSizeSelected:popupFMLEVideoInputSize];
		// input audio device
	item = [self valueForXPath:FMLEAudioDeviceNameXPath from:root];
	[popupFMLEAudioInputDevice selectItemWithTitle:item];
		// input sample rate
	item = [self valueForXPath:FMLEAudioSampleRateXPath from:root];
	[popupFMLEAudioSamplerate selectItemWithTitle:item];
		// input volume
	item = [self valueForXPath:FMLEAudioInputVolumeXPath from:root];
	self.inputVolume = [item integerValue];
		// stereo / monoral
	item = [self valueForXPath:FMLEAudioChannelsXPath from:root];
	[popupFMLEAudioOutputChannel selectItemWithTitle:([item integerValue] == 2) ? @"Stereo" : @"Mono"];

			// capture detail settings for VP6
		// keyframe frequency
	item = [self valueForXPath:FMLEAdvancedVP6KeyFrameXPath from:root];
	if (item != nil)	[popupVP6KeyframeFrequency selectItemWithTitle:item];
		// quality vs framerate
	item = [self valueForXPath:FMLEAdvancedVP6QualityXPath from:root];
	if (item != nil)	[popupVP6Quqlity selectItemWithTitle:item];
		// noise reduction
	item = [self valueForXPath:FMLEAdvancedVP6NRXpath from:root];
	if (item != nil)	[popupVP6NoiseReduction selectItemWithTitle:item];
NSLog(@"%@\t%@", item, [[popupVP6NoiseReduction selectedItem] title]);
		// datarate window
	item = [self valueForXPath:FMLEAdvancedVP6DatarateXpath from:root];
	if (item != nil)	[popupVP6DatarateWindow selectItemWithTitle:item];
		// cpu useage
	item = [self valueForXPath:FMLEAdvancedVP6CPUUseage from:root];
	if (item != nil)	[popupVP6CPUUseage selectItemWithTitle:item];

			// capture detail settings for H.264
		// profile
	item = [self valueForXPath:FMLEAdvancedH264ProfileXPath from:root];
	if (item != nil)	[popupH264Profile selectItemWithTitle:item];
		// level
	item = [self valueForXPath:FMLEAdvancedH264LevelXPath from:root];
	if (item != nil)	[popupH264Level selectItemWithTitle:item];
		// keyframe
	item = [self valueForXPath:FMLEAdvancedH264KeyFrameXPath from:root];
	if (item != nil)	[popupH264KeyframeFrequency selectItemWithTitle:item];

			// process
		// aspect ratio
	item = [self valueForXPath:FMLEVideoKeepAspectXPath from:root];
	self.preserveAspect = (item != nil) ? YES : NO;

			// encode
		// output video encode format
	item = [self valueForXPath:FMLEEncodeFormatNameXPath from:root];
	[popupFMLEVideoOutputFormat selectItemWithTitle:item];
		// output datarate
	item = [self valueForXPath:FMLEEncodeDataRateXPath from:root];
	item = [item substringWithRange:NSMakeRange(0, [item length] - 1)];
	[comboboxFMLEVideoOutputBitrate setStringValue:item];
		// encode format
	item = [self valueForXPath:FMLEEncodeAudioFormatXPath from:root];
	[popupFMLEAudioOutputFormat selectItemWithTitle:item];
	self.nellyMoserSelected = ([item isEqualToString:@"NellyNoser"] == YES) ? YES : NO;
	[self fmleEncodingFormatSelected:popupFMLEAudioOutputFormat];
		// output bitrate
	item = [self valueForXPath:FMLEEncodeAudioDataRateXPath from:root];
	[popupFMLEAudioBitrate selectItemWithTitle:item];
		// output window size
	item = [self valueForXPath:FMLEEncodeOutputSizeXPath from:root];
	NSArray *widthHeight = [item componentsSeparatedByString:VideoSizeSeparatorString];
	[txtfldFMLEVideoOutputSizeX setStringValue:[widthHeight objectAtIndex:0]];
	[txtfldFMLEVideoOutputSizeY setStringValue:[widthHeight lastObject]];
}// end - (void) loadFMLEProfile:(NSString *)profile

- (NSString *) valueForXPath:(NSString *)xPath from:(NSXMLElement *)element
{
	NSError *err = nil;
	NSArray *nodes = [element nodesForXPath:xPath error:&err];
		// check error
	if ((err != nil) || (nodes == nil) || ([nodes count] != 1))
		return nil;
		// get value
	NSXMLNode *node = [nodes lastObject];

	return [node stringValue];
}// end - (NSString *) valueForXPath:(NSString *)xPath from:(NSXMLElement *)element
@end
