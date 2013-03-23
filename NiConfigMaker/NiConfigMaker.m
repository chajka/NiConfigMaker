//
//  NiConfigMaker.m
//  NiConfigMaker
//
//  Created by Чайка on 3/16/13.
//  Copyright (c) 2013 Instrumentality of mankind. All rights reserved.
//

#import <QTKit/QTKit.h>
#import "NiConfigMaker.h"
#import "NiConfigMaker+AudioBitrateMaskProperties.h"

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

@synthesize h264Selected;
@synthesize preserveAspect;

@synthesize enableVP6KeyframeFrequency;
@synthesize enableVP6Quality;
@synthesize enableVP6NoiseReduction;
@synthesize enableVP6DatarateWindow;
@synthesize enableVP6CPUUseage;
@synthesize enableH264Level;
@synthesize enableH264Profile;
@synthesize enableH264KeyframeFrequency;

@synthesize inputVolume;
@synthesize aacSelectable;
@synthesize nellyMoserSelected;
@synthesize audioChannelTag;
@synthesize audioSampleRateTag;
@synthesize audioBitrateTag;

@synthesize samplerateStatus48000;
@synthesize samplerateStatus44100;
@synthesize samplerateStatus32000;
@synthesize samplerateStatus22050;
@synthesize samplerateStatus11025;
@synthesize samplerateStatus8000;
@synthesize samplerateStatus5512;

@synthesize	bitrateStatus320Kbps;
@synthesize	bitrateStatus256Kbps;
@synthesize	bitrateStatus224Kbps;
@synthesize	bitrateStatus192Kbps;
@synthesize	bitrateStatus160Kbps;
@synthesize	bitrateStatus128Kbps;
@synthesize	bitrateStatus112Kbps;
@synthesize	bitrateStatus96Kbps;
@synthesize bitrateStatus88Kbps;
@synthesize	bitrateStatus80Kbps;
@synthesize	bitrateStatus64Kbps;
@synthesize	bitrateStatus56Kbps;
@synthesize	bitrateStatus48Kbps;
@synthesize bitrateStatus44Kbps;
@synthesize	bitrateStatus40Kbps;
@synthesize	bitrateStatus32Kbps;
@synthesize	bitrateStatus28Kbps;
@synthesize	bitrateStatus24Kbps;
@synthesize bitrateStatus22Kbps;
@synthesize	bitrateStatus20Kbps;
@synthesize	bitrateStatus18Kbps;
@synthesize	bitrateStatus16Kbps;
@synthesize	bitrateStatus11Kbps;
#pragma mark -
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

		// setup sync checkboxes
	self.syncFrameRate = YES;
	self.syncVideoSize = YES;
}// end - (void) awakeFromNib

- (void) applicationDidFinishLaunching:(NSNotification *)notification
{
		// load startup state
	[popupFMLEProfileNames selectItemWithTitle:FMLEDefalutProfileName];
	[popupFMLEProfileNames selectItemWithTitle:FMLEDefalutProfileName];
	[self fmleProfileSelected:popupFMLEProfileNames];
	// Insert code here to initialize your application
	[drawerEncoderSettings toggle:self];
}// end - (void) applicationDidFinishLaunching:(NSNotification *)notification

#pragma mark - properties
- (NSInteger) fmleVideoEncodeTag { return fmleVideoEncodeTag; }
- (void) setFmleVideoEncodeTag:(NSInteger)value
{
	if (value == KindH264)
		aacSelectable = YES;
	else
		aacSelectable = NO;;
}// end - (void) setFmleVideoEncodeTag:value

- (NSInteger) audioEncodeFormatTag { return audioEncodeFormatTag; }
- (void) setAudioEncodeFormatTag:(NSInteger)value
{
	if (KindNellyMoser == value)
		self.nellyMoserSelected = YES;
	else
		self.nellyMoserSelected = NO;
	// end if
	audioEncodeFormatTag = value;

	NSIndexSet *indexes = nil;
	NSInteger lastIndex;
	lastIndex = [popupFMLEAudioSamplerate indexOfSelectedItem];
	indexes = [self assignSamplrateStatus:audioEncodeFormatTag];
	if ([indexes containsIndex:lastIndex] == NO)
		[popupFMLEAudioSamplerate selectItemAtIndex:[indexes firstIndex]];
	lastIndex = [popupFMLEAudioOutputBitrate indexOfSelectedItem];
	indexes = [self assignBitrateStatuses:audioEncodeFormatTag channel:audioChannelTag];
	if ([indexes containsIndex:lastIndex] == NO)
		[popupFMLEAudioOutputBitrate selectItemAtIndex:[indexes firstIndex]];
}// end - (void) setAudioEncodeTag:(NSInteger)value

- (NSInteger) audioSampleRateTag { return audioSampleRateTag; }
- (void) setAudioSampleRateTag:(NSInteger)value
{
	NSInteger lastBitrate = [popupFMLEAudioOutputBitrate indexOfSelectedItem];
	audioSampleRateTag = value;
	NSIndexSet *indexes = [self assignBitrateStatuses:audioEncodeFormatTag channel:audioChannelTag];
	if ([indexes containsIndex:lastBitrate] == NO)
		[popupFMLEAudioOutputBitrate selectItemAtIndex:[indexes firstIndex]];
}// end - (void) setAudioSampleRateTag:(NSInteger)value

- (BOOL) nellyMoserSelected { return nellyMoserSelected; }
- (void) setNellyMoserSelected:(BOOL)value
{
	if (value == YES)
	{
		self.aacSelectable = NO;
		self.audioChannelTag = KindMonoral;
	}
	nellyMoserSelected = value;

	NSIndexSet *indexes = nil;
	NSInteger lastIndex = 0;
	lastIndex = [popupFMLEAudioSamplerate indexOfSelectedItem];
	indexes = [self assignSamplrateStatus:audioEncodeFormatTag];
	if ([indexes containsIndex:lastIndex] == NO)
		[popupFMLEAudioSamplerate selectItemAtIndex:[indexes firstIndex]];
	lastIndex = [popupFMLEAudioOutputBitrate indexOfSelectedItem];
	indexes = [self assignBitrateStatuses:audioEncodeFormatTag channel:audioChannelTag];
	if ([indexes containsIndex:lastIndex] == NO)
		[popupFMLEAudioOutputBitrate selectItemAtIndex:[indexes firstIndex]];
}// end - (void) setNerryMoserSelected:(BOOL)value

#pragma mark - actions
- (IBAction) fmleProfileSelected:(NSPopUpButton *)sender
{
	NSString *profile = [[sender selectedItem] title];
	[self loadFMLEProfile:profile];
}// end - (IBAction) fmleProfileSelected:(NSPopUpButton *)sender

- (IBAction) fmleSampleRateSelected:(NSPopUpButton *)sender
{
}// end - (IBAction) fmleSampleRateSelected:(NSPopUpButton *)sender

- (IBAction) fmleFrameRateSelected:(NSPopUpButton *)sender
{
}// end - (IBAction) fmleFrameRateSelected:(NSPopUpButton *)sender

- (IBAction) fmleVideoEncodingFormatSelected:(NSPopUpButton *)sender
{		// action of popupFMLEAudioOutputFormat
	FMLEVideoFormatValue videoFormatTag = [sender selectedTag];
	FMLEAudioFormatValue audioFormatTag = [popupFMLEAudioOutputFormat selectedTag];
	switch (videoFormatTag) {
		case KindH264:
			if (audioFormatTag == KindNellyMoser)
				self.audioEncodeFormatTag = KindMP3;
			self.h264Selected = YES;
			self.nellyMoserSelected = NO;
			break;
		case KindVP6:
		default:
			if (audioFormatTag == KindAAC)
				self.audioEncodeFormatTag = KindMP3;
			self.h264Selected = NO;
			self.nellyMoserSelected = YES;
			break;
	}// end case by Video output format
}// end - (IBAction) fmleEncodingFormatSelected:(NSPopUpButton *)sender

- (IBAction) fmleAudioEncodingFormatSelected:(NSPopUpButton *)sender
{
	NSInteger selectedTag = [sender selectedTag];
	NSInteger currentAudioTag = [popupFMLEAudioOutputFormat selectedTag];
	if (KindH264 == YES)
	{
		self.aacSelectable = NO;
		if (currentAudioTag == KindAAC)
			[popupFMLEAudioOutputFormat selectItemWithTitle:EncodeTypeMP3];
	}// end if
	if (KindVP6 == selectedTag)
	{
		self.aacSelectable = YES;
		if (currentAudioTag == KindNellyMoser)
			[popupFMLEAudioOutputFormat selectItemWithTitle:EncodeTypeMP3];
	}// end if
}// end - (IBAction) fmleAudioEncodingFormatSelected:(NSPopUpButton *)sender

- (IBAction) fmleInputSizeSelected:(NSPopUpButton *)sender
{
	NSMenuItem *fmleInputSizeItem = [sender selectedItem];
	VideoSizeValue selectedVideoSizeTag = [fmleInputSizeItem tag];
	NSMenuItem *camTwistMenuItem = [[popupCamTwistVideoSize menu] itemWithTag:selectedVideoSizeTag];

	NSString *selectedSizeString = [fmleInputSizeItem title];
	NSArray *inputSizes = [selectedSizeString componentsSeparatedByString:VideoSizeSeparatorString];
	NSString *videoSizeWidth = [inputSizes objectAtIndex:0];
	NSString *videoSizeHeight = [inputSizes lastObject];
	[txtfldFMLEVideoOutputSizeX setStringValue:videoSizeWidth];
	[txtfldFMLEVideoOutputSizeY setStringValue:videoSizeHeight];

	if (syncVideoSize == YES)
	{
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
	}// end if sycronize
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
	NSXMLElement *root = [currentFMLEProfile rootElement];

			// capture
		// inut video device
	item = [self valueForXPath:FMLECaptureVideoDevice from:root];
	[popupFMLEVideoInputDeviceName selectItemWithTitle:item];
		// input video framerate
	item = [self valueForXPath:FMLECaptureVideoFrameRate from:root];
	[popupFMLEVideoFramerate selectItemWithTitle:item];
	
		// input video frame size
	NSString *width = [self valueForXPath:FMLECaptureVideoFrameWidth from:root];
	NSString *height = [self valueForXPath:FMLECaptureVideoFrameHeight from:root];
	item = [NSString stringWithFormat:VideoSizeConstructFormat, width, height];
	[popupFMLEVideoInputSize selectItemWithTitle:item];
	[self fmleInputSizeSelected:popupFMLEVideoInputSize];
		// input audio device
	item = [self valueForXPath:FMLECaptureAudioDeviceName from:root];
	[popupFMLEAudioInputDevice selectItemWithTitle:item];
		// input sample rate
	item = [self valueForXPath:FMLECaptureAudioSampleRate from:root];
	[popupFMLEAudioSamplerate selectItemWithTitle:item];
	self.audioSampleRateTag = [popupFMLEAudioSamplerate selectedTag];
		// stereo / monoral
	item = [self valueForXPath:FMLECaptureAudioChannels from:root];
	[popupFMLEAudioOutputChannel selectItemWithTitle:([item integerValue] == 2) ? ChannelStereo : ChannelMonoral];
		// input volume
	item = [self valueForXPath:FMLECaptureAudioInputVolume from:root];
	self.inputVolume = [item integerValue];

			// process
		// aspect ratio
	item = [self valueForXPath:FMLEProcessVideoPreserveAspect from:root];
	self.preserveAspect = (item != nil) ? YES : NO;

			// encode
		// output video encode format
	item = [self valueForXPath:FMLEEncodeVideoFormatName from:root];
	[popupFMLEVideoOutputFormat selectItemWithTitle:item];
	self.fmleVideoEncodeTag = [popupFMLEVideoOutputFormat selectedTag];
	self.h264Selected = (fmleVideoEncodeTag == KindH264) ? YES : NO;
		// output datarate
	item = [self valueForXPath:FMLEEncodeVideoDataRate from:root];
	item = [item substringWithRange:NSMakeRange(0, [item length] - 1)];
	[popupFMLEAudioOutputBitrate selectItemWithTitle:item];
	[comboboxFMLEVideoOutputBitrate setStringValue:item];
		// output window size
	item = [self valueForXPath:FMLEEncodeVideoOutputSize from:root];
	NSArray *widthHeight = [[item substringWithRange:(NSMakeRange(0, [item length] - 1))] componentsSeparatedByString:VideoSizeSeparatorString];
	[txtfldFMLEVideoOutputSizeX setStringValue:[widthHeight objectAtIndex:0]];
	[txtfldFMLEVideoOutputSizeY setStringValue:[widthHeight lastObject]];

			// capture detail settings for VP6
		// keyframe frequency
	item = [self valueForXPath:FMLEAdvancedVideoVP6KeyFrame from:root];
	if (item != nil)	[popupVP6KeyframeFrequency selectItemWithTitle:item];
	self.enableVP6KeyframeFrequency = (item != nil) ? YES : NO;
		// quality vs framerate
	item = [self valueForXPath:FMLEAdvancedVP6Quality from:root];
	if (item != nil)	[popupVP6Quality selectItemWithTitle:item];
	self.enableVP6Quality = (item != nil) ? YES : NO;
		// noise reduction
	item = [self valueForXPath:FMLEAdvancedVideoVP6NRXpath from:root];
	if (item != nil)	[popupVP6NoiseReduction selectItemWithTitle:item];
	self.enableVP6NoiseReduction = (item != nil) ? YES : NO;
		// datarate window
	item = [self valueForXPath:FMLEAdvancedVideoVP6Datarate from:root];
	if (item != nil)	[popupVP6DatarateWindow selectItemWithTitle:item];
	self.enableVP6DatarateWindow = (item != nil) ? YES : NO;
		// cpu useage
	item = [self valueForXPath:FMLEAdvancedVideoVP6CPUUseage from:root];
	if (item != nil)	[popupVP6CPUUseage selectItemWithTitle:item];
	self.enableVP6CPUUseage = (item != nil) ? YES : NO;

			// capture detail settings for H.264
		// profile
	item = [self valueForXPath:FMLEAdvancedH264Profile from:root];
	if (item != nil)	[popupH264Profile selectItemWithTitle:item];
	self.enableH264Profile = (item != nil) ? YES : NO;
		// level
	item = [self valueForXPath:FMLEAdvancedVideoH264Level from:root];
	if (item != nil)	[popupH264Level selectItemWithTitle:item];
	self.enableH264Level = (item != nil) ? YES : NO;
		// keyframe
	item = [self valueForXPath:FMLEAdvancedH264KeyFrame from:root];
	if (item != nil)	[popupH264KeyframeFrequency selectItemWithTitle:item];
	self.enableH264KeyframeFrequency = (item != nil) ? YES : NO;

		// encode format
	item = [self valueForXPath:FMLEEncodeAudioFormat from:root];
	[popupFMLEAudioOutputFormat selectItemWithTitle:item];
	switch ([popupFMLEAudioOutputFormat selectedTag])
	{
		case KindAAC:
			self.aacSelectable = YES;
			self.nellyMoserSelected = NO;
			break;
		case KindNellyMoser:
			self.aacSelectable = NO;
			self.nellyMoserSelected = YES;
			break;
		case KindMP3:
		default:
			self.aacSelectable = NO;
			self.nellyMoserSelected = NO;
			break;
	}// end switch
			// output bitrate
	item = [self valueForXPath:FMLEEncodeAudioDataRate from:root];
	[popupFMLEAudioOutputBitrate selectItemWithTitle:item];
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
