//
//  NiConfigMaker.h
//  NiConfigMaker
//
//  Created by Чайка on 3/16/13.
//  Copyright (c) 2013 Instrumentality of mankind. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NiConfigMakerDefinitions.h"

#if MAC_OS_X_VERSION_MIN_REQUIRED == MAC_OS_X_VERSION_10_5
@protocol NSApplicationDelegate <NSObject>
@end
#endif

@interface NiConfigMaker : NSObject <NSApplicationDelegate> {
#pragma mark - user interface variable definitons
		// common
	IBOutlet NSComboBox								*comboboxTotalBitrate;
	BOOL											adjustBitrate;
		// FMLE Configure
	IBOutlet NSPopUpButton							*popupFMLEProfileNames;
	IBOutlet NSTextField							*txtfldNewProfileName;
	BOOL											syncFrameRate;
	BOOL											syncVideoSize;

		// CamTwist Settings
	IBOutlet NSTextField							*txtfldCamTwistFramerate;
	IBOutlet NSPopUpButton							*popupCamTwistVideoSize;
	BOOL											camTwistCustomVideoSize;
	IBOutlet NSTextField							*txtfldCamTwistCustomX;
	IBOutlet NSTextField							*txtfldCamTwistCustomY;
	IBOutlet NSButton								*buttonCamTwistSaveConfig;

		// FMLE Video Settings
	BOOL											preserveAspect;
	BOOL											h264Selected;
	IBOutlet NSPopUpButton							*popupFMLEVideoFramerate;
	IBOutlet NSPopUpButton							*popupFMLEVideoOutputFormat;
		//	FMLEVideoFormatKind								fmleVideoOutputFormat;
	NSInteger										fmleVideoEncodeTag;
	IBOutlet NSPopUpButton							*popupFMLEVideoInputDeviceName;
	IBOutlet NSPopUpButton							*popupFMLEVideoInputSize;
	IBOutlet NSTextField							*txtfldFMLEVideoOutputSizeX;
	IBOutlet NSTextField							*txtfldFMLEVideoOutputSizeY;
	IBOutlet NSComboBox								*comboboxFMLEVideoOutputBitrate;
		// Video encoding settings
	IBOutlet NSDrawer								*drawerEncoderSettings;
	
		// Settings for VP6
	BOOL											enableVP6KeyframeFrequency;
	IBOutlet NSButton								*chkboxVP6KeyframeFrequency;
	IBOutlet NSPopUpButton							*popupVP6KeyframeFrequency;
	BOOL											enableVP6Quality;
	IBOutlet NSButton								*chkboxVP6Quality;
	IBOutlet NSPopUpButton							*popupVP6Quality;
	BOOL											enableVP6NoiseReduction;
	IBOutlet NSButton								*chkboxVP6NoiseReduction;
	IBOutlet NSPopUpButton							*popupVP6NoiseReduction;
	BOOL											enableVP6DatarateWindow;
	IBOutlet NSButton								*chkboxVP6DatarateWindow;
	IBOutlet NSPopUpButton							*popupVP6DatarateWindow;
	BOOL											enableVP6CPUUseage;
	IBOutlet NSButton								*chkboxVP6CPUUseage;
	IBOutlet NSPopUpButton							*popupVP6CPUUseage;
		// Settings for H.264
	BOOL											enableH264Profile;
	IBOutlet NSButton								*chkboxH264Profile;
	IBOutlet NSPopUpButton							*popupH264Profile;
	BOOL											enableH264Level;
	IBOutlet NSButton								*chkboxH264Level;
	IBOutlet NSPopUpButton							*popupH264Level;
	BOOL											enableH264KeyframeFrequency;
	IBOutlet NSButton								*chkboxH264KeyframeFrequency;
	IBOutlet NSPopUpButton							*popupH264KeyframeFrequency;

		// FMLE Audio Settings
	IBOutlet NSPopUpButton							*popupFMLEAudioInputDevice;
	IBOutlet NSPopUpButton							*popupFMLEAudioOutputFormat;
	IBOutlet NSPopUpButton							*popupFMLEAudioOutputChannel;
	IBOutlet NSPopUpButton							*popupFMLEAudioSamplerate;
	IBOutlet NSPopUpButton							*popupFMLEAudioOutputBitrate;
	IBOutlet NSSlider								*sliderFMLEAudioInputVolume;
	BOOL											aacSelectable;
	BOOL											nellyMoserSelected;
	NSInteger										inputVolume;
	NSInteger										audioEncodeFormatTag;
	NSInteger										audioChannelTag;
	NSInteger										audioSampleRateTag;
	NSInteger										audioBitrateTag;

		// current audio sample rate menu hidden flags
	BOOL											samplerateStatus48000;
	BOOL											samplerateStatus44100;
	BOOL											samplerateStatus32000;
	BOOL											samplerateStatus22050;
	BOOL											samplerateStatus11025;
	BOOL											samplerateStatus8000;
	BOOL											samplerateStatus5512;

		// current audio bit rate menu hidden flags
	BOOL											bitrateStatus320Kbps;
	BOOL											bitrateStatus256Kbps;
	BOOL											bitrateStatus224Kbps;
	BOOL											bitrateStatus192Kbps;
	BOOL											bitrateStatus160Kbps;
	BOOL											bitrateStatus128Kbps;
	BOOL											bitrateStatus112Kbps;
	BOOL											bitrateStatus96Kbps;
	BOOL											bitrateStatus88Kbps;
	BOOL											bitrateStatus80Kbps;
	BOOL											bitrateStatus64Kbps;
	BOOL											bitrateStatus56Kbps;
	BOOL											bitrateStatus48Kbps;
	BOOL											bitrateStatus44Kbps;
	BOOL											bitrateStatus40Kbps;
	BOOL											bitrateStatus32Kbps;
	BOOL											bitrateStatus28Kbps;
	BOOL											bitrateStatus24Kbps;
	BOOL											bitrateStatus22Kbps;
	BOOL											bitrateStatus20Kbps;
	BOOL											bitrateStatus18Kbps;
	BOOL											bitrateStatus16Kbps;
	BOOL											bitrateStatus11Kbps;

#pragma mark - program specific variables definitions
@protected
	NSArray											*audioDevices;
	NSArray											*videoDevides;
	NSArray											*fmleProfiles;
	NSString										*fmleProfilePath;
	NSXMLDocument									*currentFMLEProfile;
}
	// FMLE Configure
@property (assign, readwrite) BOOL					adjustBitrate;
@property (assign, readwrite) BOOL					syncFrameRate;
@property (assign, readwrite) BOOL					syncVideoSize;
	// CamTwist Settings
@property (assign, readwrite) BOOL					camTwistCustomVideoSize;
	// FMLE Video Settings
@property (assign, readwrite) BOOL					h264Selected;
@property (assign, readwrite) BOOL					preserveAspect;
@property (assign, readwrite) NSInteger				fmleVideoEncodeTag;
		// Video encoding settings
	// Settings for VP6
@property (assign, readwrite) BOOL					enableVP6KeyframeFrequency;
@property (assign, readwrite) BOOL					enableVP6Quality;
@property (assign, readwrite) BOOL					enableVP6NoiseReduction;
@property (assign, readwrite) BOOL					enableVP6DatarateWindow;
@property (assign, readwrite) BOOL					enableVP6CPUUseage;
	// Settings for H.264
@property (assign, readwrite) BOOL					enableH264Profile;
@property (assign, readwrite) BOOL					enableH264Level;
@property (assign, readwrite) BOOL					enableH264KeyframeFrequency;
	// FMLE Audio Settings
@property (assign, readwrite) NSInteger				inputVolume;
@property (assign, readwrite) BOOL					aacSelectable;
@property (assign, readwrite) BOOL					nellyMoserSelected;
@property (assign, readwrite) NSInteger				audioEncodeFormatTag;
@property (assign, readwrite) NSInteger				audioChannelTag;
@property (assign, readwrite) NSInteger				audioSampleRateTag;
@property (assign, readwrite) NSInteger				audioBitrateTag;

	// current audio sampling rate show / hidden flags
@property (assign, readwrite) BOOL					samplerateStatus48000;
@property (assign, readwrite) BOOL					samplerateStatus44100;
@property (assign, readwrite) BOOL					samplerateStatus32000;
@property (assign, readwrite) BOOL					samplerateStatus22050;
@property (assign, readwrite) BOOL					samplerateStatus11025;
@property (assign, readwrite) BOOL					samplerateStatus8000;
@property (assign, readwrite) BOOL					samplerateStatus5512;
	// current audio bit rate menu show / hidden flags
@property (assign, readwrite) BOOL					bitrateStatus320Kbps;
@property (assign, readwrite) BOOL					bitrateStatus256Kbps;
@property (assign, readwrite) BOOL					bitrateStatus224Kbps;
@property (assign, readwrite) BOOL					bitrateStatus192Kbps;
@property (assign, readwrite) BOOL					bitrateStatus160Kbps;
@property (assign, readwrite) BOOL					bitrateStatus128Kbps;
@property (assign, readwrite) BOOL					bitrateStatus112Kbps;
@property (assign, readwrite) BOOL					bitrateStatus96Kbps;
@property (assign, readwrite) BOOL					bitrateStatus88Kbps;
@property (assign, readwrite) BOOL					bitrateStatus80Kbps;
@property (assign, readwrite) BOOL					bitrateStatus64Kbps;
@property (assign, readwrite) BOOL					bitrateStatus56Kbps;
@property (assign, readwrite) BOOL					bitrateStatus48Kbps;
@property (assign, readwrite) BOOL					bitrateStatus44Kbps;
@property (assign, readwrite) BOOL					bitrateStatus40Kbps;
@property (assign, readwrite) BOOL					bitrateStatus32Kbps;
@property (assign, readwrite) BOOL					bitrateStatus28Kbps;
@property (assign, readwrite) BOOL					bitrateStatus24Kbps;
@property (assign, readwrite) BOOL					bitrateStatus22Kbps;
@property (assign, readwrite) BOOL					bitrateStatus20Kbps;
@property (assign, readwrite) BOOL					bitrateStatus18Kbps;
@property (assign, readwrite) BOOL					bitrateStatus16Kbps;
@property (assign, readwrite) BOOL					bitrateStatus11Kbps;

#pragma mark - actions
- (IBAction) fmleProfileSelected:(NSPopUpButton *)sender;
- (IBAction) fmleSampleRateSelected:(NSPopUpButton *)sender;
- (IBAction) fmleFrameRateSelected:(NSPopUpButton *)sender;
- (IBAction) fmleVideoEncodingFormatSelected:(NSPopUpButton *)sender;
- (IBAction) fmleAudioEncodingFormatSelected:(NSPopUpButton *)sender;
- (IBAction) fmleInputSizeSelected:(NSPopUpButton *)sender;
- (IBAction) camTwistVideoSizeSelected:(NSPopUpButton *)sender;
- (IBAction) camTwistSaveConfig:(NSButton *)sender;

@end
