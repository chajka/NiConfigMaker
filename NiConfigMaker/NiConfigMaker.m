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
- (void) initializeMembers;
- (NSDictionary *) titleVsTagDictionary:(NSPopUpButton *)popup;
- (NSDictionary *) camTwistPreference;
- (void) loadCamTwistProfile;
- (void) buildCamTwistPrefs;
- (void) copyVideoSizeFromFMLEToCamTwist;
- (NSArray *) collectFMLEProfiles;
- (void) loadFMLEProfile:(NSString *)profile;
- (NSString *) valueForXPath:(NSString *)xPath from:(NSXMLElement *)element;
- (BOOL) rebuildProfile;
- (void) setAspectRatio:(BOOL)enable to:(NSXMLElement *)element;
- (void) setValue:(NSString *)value ofXPath:(NSString *)xPath to:(NSXMLElement *)element;
- (NSInteger) selectNewItem:(NSPopUpButton *)popup lastIndex:(NSUInteger)lastIndex;
@end

@implementation NiConfigMaker
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
@synthesize nellyMoserSelected;

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
		currentFMLEProfile = nil;
		fmleProfiles = [self collectFMLEProfiles];
		camTwistPrefs = [[NSMutableDictionary alloc] initWithDictionary:[self camTwistPreference]];
		syncFrameRate = NO;
		syncVideoSize = NO;
	}// end if

	return self;
}// end - (id) init

- (void) dealloc
{
	if (fmleProfiles != nil)			[fmleProfiles release];
	if (camTwistPrefs != nil)			[camTwistPrefs release];

	if (videoOutputFormatDict != nil)	[videoOutputFormatDict release];
	if (audioOutputFormatDict != nil)	[audioOutputFormatDict release];
	if (audioSamplerateDict != nil)		[audioSamplerateDict release];
	if (audioChannelDict != nil)		[audioChannelDict release];
	if (audioBitrateDict != nil)		[audioBitrateDict release];

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

		// CamTwist preference
	[self loadCamTwistProfile];
	
		// fmle profiles
	[popupFMLEProfileNames removeAllItems];
	[popupFMLEProfileNames addItemsWithTitles:fmleProfiles];
	[[[popupFMLEProfileNames  menu] itemAtIndex:0] setState:NSOnState];

		// setup sync checkboxes
	self.syncFrameRate = NO;
	self.syncVideoSize = NO;

	[self initializeMembers];
}// end - (void) awakeFromNib

- (void) applicationDidFinishLaunching:(NSNotification *)notification
{
		// load startup state
	[self fmleProfileSelected:popupFMLEProfileNames];
	// Insert code here to initialize your application
	[drawerEncoderSettings toggle:self];
}// end - (void) applicationDidFinishLaunching:(NSNotification *)notification

#pragma mark - properties
- (NSInteger) tagVideoOutputFormat { return tagVideoOutputFormat; }
- (void) setTagVideoOutputFormat:(NSInteger)value
{
	NSInteger lastTag = tagAudioOutputFormat;
	tagVideoOutputFormat = value;
	self.h264Selected = (tagVideoOutputFormat == KindH264) ? YES : NO;
	NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
	for (NSMenuItem *item in [popupFMLEAudioOutputFormat itemArray])
	{
		if ([item isHidden] == NO)
			[indexes addIndex:[item tag]];
		// end if item is not hidden
	}// end foreach video output format

	if ([indexes containsIndex:lastTag] == NO)
		self.tagAudioOutputFormat = [indexes firstIndex];
	// end if must select new item
}// end - (void) settagVideoOutputFormat:(NSInteger):value

- (NSInteger) tagAudioOutputFormat { return tagAudioOutputFormat; }
- (void) setTagAudioOutputFormat:(NSInteger)value
{
	if (value == KindNellyMoser)
		self.tagAudioChannel = KindMonoral;
	self.nellyMoserSelected = (value == KindNellyMoser) ? YES : NO;
	NSInteger lastTag = tagAudioSamplerate;
	tagAudioOutputFormat = value;
	NSIndexSet *sampleRateIndexes = [self assignSamplrateByEncode:tagAudioOutputFormat];
	self.tagAudioSamplerate =  ([sampleRateIndexes containsIndex:lastTag] == YES) ? lastTag : [sampleRateIndexes firstIndex];
}// end - (void) settagAudioOutputFormat:(NSInteger):value

- (NSInteger) tagAudioSamplerate { return tagAudioSamplerate; }
- (void) setTagAudioSamplerate:(NSInteger)value
{
	tagAudioSamplerate = value;
	NSInteger lastTag = tagAudioBitrate;
	
	NSIndexSet *bitrateIndexes = [self assignBitrateByEncode:tagAudioOutputFormat samplerate:tagAudioSamplerate channel:tagAudioChannel];
	self.tagAudioBitrate = ([bitrateIndexes containsIndex:lastTag] == YES) ? lastTag: [bitrateIndexes firstIndex];
}// end - (void) settagAudioSamplerate:(NSInteger):value

- (NSInteger) tagAudioChannel { return tagAudioChannel; }
- (void) setTagAudioChannel:(NSInteger)value
{
	tagAudioChannel = value;
	NSInteger lastTag = tagAudioBitrate;
	
	NSIndexSet *bitrateIndexes = [self assignBitrateByEncode:tagAudioOutputFormat samplerate:tagAudioSamplerate channel:tagAudioChannel];
	self.tagAudioBitrate = ([bitrateIndexes containsIndex:lastTag] == YES) ? lastTag: [bitrateIndexes firstIndex];
}// end - (void) settagAudioChannel:(NSInteger):value

- (NSInteger) tagAudioBitrate { return tagAudioBitrate; }
- (void) setTagAudioBitrate:(NSInteger)value
{
	tagAudioBitrate = value;
}// end - (void) settagAudioBitrate:(NSInteger):value

- (BOOL) syncFrameRate { return syncFrameRate; }
- (void) setSyncFrameRate:(BOOL)value
{
	syncFrameRate = value;
	if (syncFrameRate == YES)
		[txtfldCamTwistFramerate setStringValue:[[popupFMLEVideoFramerate selectedItem] title]];
}// end - (void) setSyncFrameRate:(BOOL)value

- (BOOL) syncVideoSize { return syncVideoSize; }
- (void) setSyncVideoSize:(BOOL)value
{
	syncVideoSize = value;
	if (syncVideoSize == YES)
		[self copyVideoSizeFromFMLEToCamTwist];
}// end - (void) setSyncVideoSize:(BOOL)value

#pragma mark - actions
- (IBAction) fmleProfileSelected:(NSPopUpButton *)sender
{
	NSString *profile = [[sender selectedItem] title];
	[self loadFMLEProfile:profile];
}// end - (IBAction) fmleProfileSelected:(NSPopUpButton *)sender

- (IBAction) fmleFrameRateSelected:(NSPopUpButton *)sender
{
	if (syncFrameRate == YES)
		[txtfldCamTwistFramerate setStringValue:[[popupFMLEVideoFramerate selectedItem] title]];
}// end - (IBAction) fmleFrameRateSelected:(NSPopUpButton *)sender

- (IBAction) fmleInputSizeSelected:(NSPopUpButton *)sender
{
	NSMenuItem *fmleInputSizeItem = [sender selectedItem];

	NSString *selectedSizeString = [fmleInputSizeItem title];
	NSArray *inputSizes = [selectedSizeString componentsSeparatedByString:VideoSizeSeparatorString];
	NSString *videoSizeWidth = [inputSizes objectAtIndex:0];
	NSString *videoSizeHeight = [inputSizes lastObject];
	[txtfldFMLEVideoOutputSizeX setStringValue:videoSizeWidth];
	[txtfldFMLEVideoOutputSizeY setStringValue:videoSizeHeight];
}// end - (IBAction) fmleInputSizeSelected:(NSPopUpButton *)sender

- (IBAction) adjustBitrate:(NSButton *)sender
{
		// must be calc bitrate
	NSString *totalBitrateString = [comboboxTotalBitrate stringValue];
		// check goal bitrate is not empty
	if ((totalBitrateString == nil) || ([totalBitrateString isEqualToString:@""] == YES))
		return;
	
		// calc bitrate
	NSInteger totalBitrate = [totalBitrateString integerValue];
	NSInteger audioBitrate = [[popupFMLEAudioOutputBitrate title] integerValue];
	NSInteger videoOutBitrate = totalBitrate - audioBitrate;
	NSNumber *bitrate = [NSNumber numberWithInteger:videoOutBitrate];
	[comboboxFMLEVideoOutputBitrate addItemWithObjectValue:bitrate];
	[comboboxFMLEVideoOutputBitrate selectItemWithObjectValue:bitrate];
}// end - (void) setAdjustBitrate

- (IBAction) fmleSaveProfile:(NSButton *)sender
{
	NSString *saveProfileName = [txtfldNewProfileName stringValue];
	if ([self rebuildProfile] == YES)
	{
		NSData *xmlData = [currentFMLEProfile XMLDataWithOptions:NSUTF16StringEncoding|NSXMLDocumentTidyXML|NSXMLNodePrettyPrint];
		if (xmlData == nil)
			return;
		// end if

		NSString *profilePath = [fmleProfilePath stringByAppendingPathComponent:saveProfileName];
		profilePath = [profilePath stringByAppendingPathExtension:FMLEProfileExtension];
		NSFileManager *fm = [NSFileManager defaultManager];
		if ([fm fileExistsAtPath:profilePath] == NO)
			[fm createFileAtPath:profilePath contents:nil attributes:nil];
			
		NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:profilePath];
		[outFile writeData:xmlData];
		[outFile truncateFileAtOffset:[outFile offsetInFile]];
	}// end if succes build profile
}// end - (IBAction) fmleSaveProfile:(NSButton *)sender

- (IBAction) removeFMLEProfile:(NSButton *)sender
{
	NSString *profileName = [[popupFMLEProfileNames selectedItem] title];
	NSString *path = [[fmleProfilePath stringByAppendingPathComponent:profileName] stringByAppendingPathExtension:FMLEProfileExtension];

	NSError *err = nil;
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:path error:&err];
}// end - (IBAction) removeFMLEProfile:(NSButton *)sender

- (IBAction) camTwistVideoSizeSelected:(NSPopUpButton *)sender
{
	[txtfldCamTwistCustomWidth setStringValue:@""];
	[txtfldCamTwistCustomHeight setStringValue:@""];
	self.camTwistCustomVideoSize = NO;
}// end - (IBAction) camTwistVideoSizeSelected:(NSPopUpButton *)sender

- (IBAction) camTwistSaveConfig:(NSButton *)sender
{
	[self buildCamTwistPrefs];

	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *camTwistBackupFile = [[camTwistPrefPath stringByDeletingPathExtension] stringByAppendingPathExtension:BackupFilePathExtension];
	NSError *err = nil;
	if ([fm fileExistsAtPath:camTwistBackupFile])
		[fm removeItemAtPath:camTwistBackupFile error:&err];
	if (err == nil)
		[fm moveItemAtPath:camTwistPrefPath toPath:camTwistBackupFile error:&err];
	if (err == nil)
		[camTwistPrefs writeToFile:camTwistPrefPath atomically:YES];
}// end - (IBAction) camTwistSaveConfig:(NSButton *)sender

#pragma mark - private
- (void) initializeMembers
{
	videoOutputFormatDict = [[NSDictionary alloc] initWithDictionary:
							 [self titleVsTagDictionary:popupFMLEVideoOutputFormat]];
	audioOutputFormatDict = [[NSDictionary alloc] initWithDictionary:
							 [self titleVsTagDictionary:popupFMLEAudioOutputFormat]];
	audioSamplerateDict = [[NSDictionary alloc] initWithDictionary:
						   [self titleVsTagDictionary:popupFMLEAudioSamplerate]];
	audioChannelDict = [[NSDictionary alloc] initWithObjectsAndKeys:
						[NSNumber numberWithInteger:KindStereo], ChannelStereo,
						[NSNumber numberWithInteger:KindMonoral], ChannelMonoral, nil];
	audioBitrateDict = [[NSDictionary alloc] initWithDictionary:
						[self titleVsTagDictionary:popupFMLEAudioOutputBitrate]];
}// end - (void) initializeMembers

- (NSDictionary *) titleVsTagDictionary:(NSPopUpButton *)popup
{
	NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
	NSNumber *tag = nil;
	NSString *title = nil;
		// audio output dictionary
	for (NSMenuItem *item in [popup itemArray])
	{
		tag = [NSNumber numberWithInteger:[item tag]];
		title = [item title];
		if ([title isEqualToString:@""] == NO)
			[tmpDict setValue:tag forKey:title];
	}// end foreach video output format;

	return ([tmpDict count] == 0) ? nil :
			[NSDictionary dictionaryWithDictionary:tmpDict];
}// end - (NSDictionary *) titleVsTagDictionary:(NSPopUpButton *)popup

- (NSDictionary *) camTwistPreference
{
	camTwistPrefPath = [[NSString alloc] initWithString:[CamTwistConfigFilePath stringByExpandingTildeInPath]];
	NSDictionary *pref = [NSDictionary dictionaryWithContentsOfFile:camTwistPrefPath];
	
	return pref;
}// end - (NSDictionary *) camTwistPreference

- (void) loadCamTwistProfile
{
	NSNumber *framerate = [camTwistPrefs valueForKey:CamTwistKeyFrameRate];
	[txtfldCamTwistFramerate setStringValue:[framerate stringValue]];
	NSString *videoSizeString = [camTwistPrefs valueForKey:CamTwistKeyVideoSize];
	videoSizeString = [videoSizeString substringWithRange:
					   NSMakeRange(1, [videoSizeString length] -2)];
	NSArray	*videoSizeArray = [videoSizeString componentsSeparatedByString:CamTwistVideoSizeSplitter];
	videoSizeString = [videoSizeArray componentsJoinedByString:VideoSizeSeparatorString];

	NSArray *videoSizes = [popupCamTwistVideoSize itemTitles];
	for (NSString *size in videoSizes)
	{
		if ([size isEqualToString:videoSizeString])
		{
			[popupCamTwistVideoSize selectItemWithTitle:size];
			return;
		}// end if found size in popup menu
	}// end foreach video sizes

		// not found -> be custome size
	[txtfldCamTwistCustomWidth setStringValue:[videoSizeArray objectAtIndex:0]];
	[txtfldCamTwistCustomHeight setStringValue:[videoSizeArray lastObject]];
	self.camTwistCustomVideoSize = YES;
}// end - (void) loadCamTwistProfile

- (void) buildCamTwistPrefs
{		// set framerate
	NSString *framerateString = [txtfldCamTwistFramerate stringValue];
	NSNumber *framerate = [NSNumber numberWithInteger:[framerateString integerValue]];
	[camTwistPrefs setValue:framerate forKey:CamTwistKeyFrameRate];

		// get window width height
	NSString *width = nil;
	NSString *height = nil;
	if (camTwistCustomVideoSize == NO)
	{
		NSString *widthHeight = [[popupCamTwistVideoSize selectedItem] title];
		NSArray *sizeArray = [widthHeight componentsSeparatedByString:VideoSizeSeparatorString];
		width = [sizeArray objectAtIndex:0];
		height = [sizeArray lastObject];
	}
	else
	{
		width = [txtfldCamTwistCustomWidth stringValue];
		height = [txtfldCamTwistCustomHeight stringValue];
	}
	
	NSString *camTwistVideoOutputString = [NSString stringWithFormat:CamTwistVideoSizeFormat, width, height];
	[camTwistPrefs setValue:camTwistVideoOutputString forKey:CamTwistKeyVideoSize];
	[camTwistPrefs setValue:[NSNumber numberWithBool:camTwistCustomVideoSize] forKey:CamTwistKeyCustomVideoSize];
}// end - (void) buildCamTwistPrefs

- (void) copyVideoSizeFromFMLEToCamTwist
{
	NSMenuItem *fmleInputSizeItem = [popupFMLEVideoInputSize selectedItem];
	
	NSString *selectedSizeString = [fmleInputSizeItem title];
	NSArray *inputSizes = [selectedSizeString componentsSeparatedByString:VideoSizeSeparatorString];
	NSString *videoSizeWidth = [inputSizes objectAtIndex:0];
	NSString *videoSizeHeight = [inputSizes lastObject];
	
	VideoSizeValue selectedVideoSizeTag = [fmleInputSizeItem tag];
	NSMenuItem *camTwistMenuItem = [[popupCamTwistVideoSize menu] itemWithTag:selectedVideoSizeTag];
	if (syncVideoSize == YES)
	{
		if (camTwistMenuItem != nil)
		{
			[popupCamTwistVideoSize selectItemWithTag:selectedVideoSizeTag];
			self.camTwistCustomVideoSize = NO;
			return;
		}// end if CamTwist video size menu have fmle selected video size
		
			// selected video size is not found in CamTwistMenu
		[txtfldCamTwistCustomWidth setStringValue:videoSizeWidth];
		[txtfldCamTwistCustomHeight setStringValue:videoSizeHeight];
		
		self.camTwistCustomVideoSize = YES;
	}// end if sycronize
}// end - (void) copyVideoSizeFromFMLEToCamTwist

- (NSArray *) collectFMLEProfiles
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
}// end - (NSArray *) collectFMLEProfiles

- (void) loadFMLEProfile:(NSString *)profile
{
	if (currentFMLEProfile != nil)		[currentFMLEProfile release];

		// load profile
	NSNumber *tag = nil;
	NSError *err = nil;
	NSString *profilePath = [fmleProfilePath stringByAppendingPathComponent:profile];
	profilePath = [profilePath stringByAppendingPathExtension:FMLEProfileExtension];
	NSData *profileData = [NSData dataWithContentsOfFile:profilePath];
	currentFMLEProfile = [[NSXMLDocument alloc] initWithData:profileData options:NSUTF16StringEncoding|NSXMLDocumentTidyXML error:&err];

		// parse and set to panel
	NSString *item = nil;
	NSXMLElement *root = [currentFMLEProfile rootElement];
	if ((err != nil) || (root == nil))
		return;

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
	item = [NSString stringWithFormat:FMLEVideoSizeConstructFormat, width, height];
	[popupFMLEVideoInputSize selectItemWithTitle:item];
		// input audio device
	item = [self valueForXPath:FMLECaptureAudioDeviceName from:root];
	[popupFMLEAudioInputDevice selectItemWithTitle:item];
		// input sample rate
	item = [self valueForXPath:FMLECaptureAudioSampleRate from:root];
		//tag = [[audioSamplerateDict valueForKey:item] integerValue];
		//[popupFMLEAudioSamplerate selectItemWithTitle:item];
	tag = [audioSamplerateDict valueForKey:item];
	self.tagAudioSamplerate = [tag integerValue];
		// stereo / monoral
	item = [self valueForXPath:FMLECaptureAudioChannels from:root];
		//[popupFMLEAudioOutputChannel selectItemWithTitle:([item integerValue] == 2) ? ChannelStereo : ChannelMonoral];
	tag = [audioChannelDict valueForKey:item];
	self.tagAudioChannel = [tag integerValue];
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
	tag = [videoOutputFormatDict valueForKey:item];
	self.tagVideoOutputFormat = [tag integerValue];
		// output datarate
	item = [self valueForXPath:FMLEEncodeVideoDataRate from:root];
	item = [item substringWithRange:NSMakeRange(0, [item length] - 1)];
		//[popupFMLEAudioOutputBitrate selectItemWithTitle:item];
		//self.tagAudioBitrate = [[audioBitrateDict valueForKey:item] integerValue];
	[comboboxFMLEVideoOutputBitrate setStringValue:item];
		// output window size
	item = [self valueForXPath:FMLEEncodeVideoOutputSize from:root];
	NSArray *widthHeight = [[item substringWithRange:(NSMakeRange(0, [item length] - 1))] componentsSeparatedByString:VideoSizeSeparatorString];
	[txtfldFMLEVideoOutputSizeX setStringValue:[widthHeight objectAtIndex:0]];
	[txtfldFMLEVideoOutputSizeY setStringValue:[widthHeight lastObject]];

	self.enableH264Profile =  NO;
	self.enableH264Level = NO;
	self.enableH264KeyframeFrequency = NO;

	self.enableVP6KeyframeFrequency = NO;
	self.enableVP6Quality = NO;
	self.enableVP6NoiseReduction = NO;
	self.enableVP6NoiseReduction = NO;
	self.enableVP6DatarateWindow = NO;
	self.enableVP6CPUUseage = NO;

	if (h264Selected == YES)
	{	// capture detail settings for H.264
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
	}
	else
	{	// capture detail settings for VP6
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
	}
	
		// encode format
	item = [self valueForXPath:FMLEEncodeAudioFormat from:root];
	self.tagAudioOutputFormat = [[audioOutputFormatDict valueForKey:item] integerValue];
		//[popupFMLEAudioOutputFormat selectItemWithTitle:item];
		// output bitrate
	item = [self valueForXPath:FMLEEncodeAudioDataRate from:root];
		//[popupFMLEAudioOutputBitrate selectItemWithTitle:item];
	tag = [audioBitrateDict valueForKey:item];
	self.tagAudioBitrate = [tag integerValue];

		//	[self fmleInputSizeSelected:popupFMLEVideoInputSize];
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

- (BOOL) rebuildProfile
{
	BOOL success = YES;
	@try {
		NSError *err;
		NSXMLElement *root = [currentFMLEProfile rootElement];
		NSString *value = nil;
				// capture
			// video
		value = [[popupFMLEVideoInputDeviceName selectedItem] title];
		[self setValue:value ofXPath:FMLECaptureVideoDevice to:root];
		
		value = [[popupFMLEVideoFramerate selectedItem] title];
		[self setValue:value ofXPath:FMLECaptureVideoFrameRate to:root];
		
		value = [[popupFMLEVideoInputSize selectedItem] title];
		NSArray *widthHeight = [value componentsSeparatedByString:VideoSizeSeparatorString];
		[self setValue:[widthHeight objectAtIndex:0] ofXPath:FMLECaptureVideoFrameWidth to:root];
		[self setValue:[widthHeight lastObject] ofXPath:FMLECaptureVideoFrameHeight to:root];
			// audio
		value = [[popupFMLEAudioInputDevice selectedItem] title];
		[self setValue:value ofXPath:FMLECaptureAudioDeviceName to:root];
		
		value = [[popupFMLEAudioSamplerate selectedItem] title];
		[self setValue:value ofXPath:FMLECaptureAudioSampleRate to:root];
		
		value = ([[[popupFMLEAudioOutputChannel selectedItem] title] isEqualToString:Stereo] == YES) ?
		ChannelStereo : ChannelMonoral;
		[self setValue:value ofXPath:FMLECaptureAudioChannels to:root];
		
		value = [NSString stringWithFormat:@"%ld", (long)inputVolume];
		[self setValue:value ofXPath:FMLECaptureAudioInputVolume to:root];
				// process
		[self setAspectRatio:preserveAspect to:root];

				// encode
			// video
		value = [[popupFMLEVideoOutputFormat selectedItem] title];
		BOOL vp6 = [value isEqualToString:EncodeTypeVP6];
		[self setValue:value ofXPath:FMLEEncodeVideoFormatName to:root];
		value = [NSString stringWithFormat:FMLEDatarateOutputSizeFormat,
				 [comboboxFMLEVideoOutputBitrate stringValue]];
		[self setValue:value ofXPath:FMLEEncodeVideoDataRate to:root];
		NSString *width = [txtfldFMLEVideoOutputSizeX stringValue];
		NSString *height = [txtfldFMLEVideoOutputSizeY stringValue];
		value = [NSString stringWithFormat:VideoSizeConstructFormat, width, height];
		[self setValue:value ofXPath:FMLEEncodeVideoOutputSize to:root];

				// video advanced
			// detach avdanced
		NSArray *advancedNodes = [root nodesForXPath:FMLEVideoAdvanced error:&err];
		if ((err != nil) || (advancedNodes != nil))
			for (NSXMLNode *node in advancedNodes)
				[node detach];
		NSMutableArray *advanced = [NSMutableArray array];
		NSXMLNode *advancedNode = nil;
		if (vp6 == YES)
		{		// VP6
			if (enableVP6KeyframeFrequency == YES)
			{
				advancedNode = [NSXMLNode elementWithName:FMLEAdvancedVP6KeyFrameName stringValue:[[popupVP6KeyframeFrequency selectedItem] title]];
				[advanced addObject:advancedNode];
			}
			if (enableVP6Quality == YES)
			{
				advancedNode = [NSXMLNode elementWithName:FMLEAdvancedVP6QualityName stringValue:[[popupVP6Quality selectedItem] title]];
				[advanced addObject:advancedNode];
			}
			if (enableVP6NoiseReduction == YES)
			{
				advancedNode = [NSXMLNode elementWithName:FMLEAdvancedVP6NRName stringValue:[[popupVP6NoiseReduction selectedItem] title]];
				[advanced addObject:advancedNode];
			}
			if (enableVP6DatarateWindow == YES)
			{
				advancedNode = [NSXMLNode elementWithName:FMLEAdvancedVP6DRWindowName stringValue:[[popupVP6DatarateWindow selectedItem] title]];
				[advanced addObject:advancedNode];
			}
			if (enableVP6CPUUseage == YES)
			{
				advancedNode = [NSXMLNode elementWithName:FMLEAdvancedVP6CPUUseName stringValue:[[popupVP6CPUUseage selectedItem] title]];
				[advanced addObject:advancedNode];
			}
		}// end VP6
		else
		{
				// H.264
			if (enableH264Profile == YES)
			{
				advancedNode = [NSXMLNode elementWithName:FMLEAdvancedH264ProfName stringValue:[[popupH264Profile selectedItem] title]];
				[advanced addObject:advancedNode];
			}
			if (enableH264Level == YES)
			{
				advancedNode = [NSXMLNode elementWithName:FMLEAdvancedH264LevelName stringValue:[[popupH264Level selectedItem] title]];
				[advanced addObject:advancedNode];
			}
			if (enableH264KeyframeFrequency)
			{
				advancedNode = [NSXMLNode elementWithName:FMLEAdvancedH264KeyFrameName stringValue:[[popupH264KeyframeFrequency selectedItem] title]];
				[advanced addObject:advancedNode];
			}
		}// end H.264
		if ([advanced count] != 0)
		{
			NSXMLNode *advancedNode = [NSXMLNode elementWithName:FMLEVideoAdvancedNodeName children:advanced attributes:nil];
			NSXMLElement *elem = [[root elementsForName:FMLEElementKeyEncode] lastObject];
			elem = [[elem elementsForName:FMLEElementKeyVideo] lastObject];
			[elem insertChild:advancedNode atIndex:3];
		}// end

			// audio
		value = [[popupFMLEAudioOutputFormat selectedItem] title];
		[self setValue:value ofXPath:FMLEEncodeAudioFormat to:root];
		value = [[popupFMLEAudioOutputBitrate selectedItem] title];
		[self setValue:value ofXPath:FMLEEncodeAudioDataRate to:root];
	}
	@catch (NSException *exception) {
		NSLog(@"Exception rised");
		success = NO;
	}// end try-catch block

	return success;
}// end - (BOOL) rebuildProfile

- (void) setAspectRatio:(BOOL)enable to:(NSXMLElement *)element
{
	NSError *err = nil;
		// check have aspect node
	NSArray *nodes = [element nodesForXPath:FMLEProcessVideoPreserveAspect error:&err];
	BOOL haveAspect = !((err != nil) || (nodes == nil) | ([nodes count] != 1));

		// process aspect ratio
	if (enable == YES)
	{		// enable aspect ratio
		if (haveAspect == YES)
			return;	// already there nothing to do
		// end if set aspect but already there

			// create & add
		NSXMLNode *aspect = [NSXMLNode elementWithName:FMLEAspectElementName];
		NSXMLNode *video = [NSXMLNode elementWithName:FMLEProcessVideoElementName children:[NSArray arrayWithObject:aspect] attributes:nil];
		NSXMLNode *process = [NSXMLNode elementWithName:FMLEProcessElementName children:[NSArray arrayWithObject:video] attributes:nil];
		[element insertChild:process atIndex:2];
		return;
	}
	else
	{		// disable (remove aspect ratio)
		if (haveAspect == NO)
			return; // not entry nothing to do
		// end remove but not entry

		nodes = [element nodesForXPath:FMLEProcess error:&err];
			// detach
		for (NSXMLNode *node in nodes)
			[node detach];
		// end foreach detach node
	}
}// end - (void) setAspectRatio:(BOOL)enable to:(NSXMLElement *)element

- (void) setValue:(NSString *)value ofXPath:(NSString *)xPath to:(NSXMLElement *)element
{
	NSError *err = nil;
	NSArray *nodes = [element nodesForXPath:xPath error:&err];
	if ((err != nil) || (nodes == nil) || ([nodes count] != 1))
		@throw [NSException exceptionWithName:[err description] reason:[err domain] userInfo:nil];

	NSXMLNode *node = [nodes objectAtIndex:0];
	if (value != nil)
		[node setStringValue:value];
	else
		[node detach];
}// end - (void) setValue:(NSString *)value ofXPath:(NSString *)xPath to:(NSXMLElement *)element

- (NSInteger) selectNewItem:(NSPopUpButton *)popup lastIndex:(NSUInteger)lastIndex
{
	NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
	NSUInteger index = 0;
	for (NSMenuItem *item in [popup itemArray])
	{
		if ([item isHidden] == NO)
			[indexes addIndex:index];
		index++;
	}// end foreach collect visible popup menu items

		// check last item contents new popup menu’s visible contents
	if ([indexes containsIndex:lastIndex] == NO)
		[popup selectItemAtIndex:[indexes firstIndex]];

	return [popup selectedTag];
}// end  - (void) selectNewItem:(NSPopUpButton *)popup lastIndex:(NSUInteger)lastIndex
@end
