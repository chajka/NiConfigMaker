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

		// FMLE Audio Settings
	IBOutlet NSPopUpButton							*popupFMLEAudioInputDevice;
	IBOutlet NSPopUpButton							*popupFMLEAudioOutputFormat;
	FMLEAudioFormatKind								fmleAudioOutputFormat;
	BOOL											nellyMoserSelected;
	IBOutlet NSPopUpButton							*popupFMLEAudioOutputChannel;
	IBOutlet NSPopUpButton							*popupFMLEAudioSamplerate;
	IBOutlet NSPopUpButton							*popupFMLEAudioBitrate;
	IBOutlet NSSlider								*sliderFMLEAudioInputVolume;
	NSInteger										inputVolume;

		// FMLE Video Settings
	BOOL											preserveAspect;
	IBOutlet NSPopUpButton							*popupFMLEVideoFramerate;
	IBOutlet NSPopUpButton							*popupFMLEVideoOutputFormat;
	FMLEVideoFormatKind								fmleVideoOutputFormat;
	BOOL											h264Selected;
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
	BOOL											aacSelected;
	

#pragma mark - program specific variables definitions
@protected
	NSArray											*audioDevices;
	NSArray											*videoDevides;
	NSArray											*fmleProfiles;
	NSString										*fmleProfilePath;
	NSXMLDocument									*currentFMLEProfile;
	BOOL											nerryMoser44100;
	BOOL											nerryMoser22050;
	BOOL											nerryMoser11025;
	BOOL											nerryMoser8000;
	BOOL											nerryMoser5512;
	BOOL											mp3Stereo44100;
	BOOL											mp3Stereo22050;
	BOOL											mp3Stereo11025;
	BOOL											mp3Monoral44100;
	BOOL											mp3Monoral22050;
	BOOL											mp3Monoral11025;
	BOOL											aacCommonBitrate;
	BOOL											aacMonoral11025;
	BOOL											aacStereo8000;
	BOOL											aacMonoral8000;
}
@property (assign, readwrite) BOOL					adjustBitrate;
@property (assign, readwrite) BOOL					syncFrameRate;
@property (assign, readwrite) BOOL					syncVideoSize;
@property (assign, readwrite) BOOL					camTwistCustomVideoSize;
@property (assign, readwrite) FMLEAudioFormatKind	fmleAudioOutputFormat;
@property (assign, readwrite) BOOL					nellyMoserSelected;
@property (assign, readwrite) BOOL					h264Selected;
@property (assign, readwrite) NSInteger				inputVolume;
@property (assign, readwrite) BOOL					preserveAspect;
@property (assign, readwrite) FMLEVideoFormatKind	fmleVideoOutputFormat;
@property (assign, readwrite) BOOL					enableVP6KeyframeFrequency;
@property (assign, readwrite) BOOL					enableVP6Quality;
@property (assign, readwrite) BOOL					enableVP6NoiseReduction;
@property (assign, readwrite) BOOL					enableVP6DatarateWindow;
@property (assign, readwrite) BOOL					enableVP6CPUUseage;
@property (assign, readwrite) BOOL					enableH264Profile;
@property (assign, readwrite) BOOL					enableH264Level;
@property (assign, readwrite) BOOL					enableH264KeyframeFrequency;
@property (assign, readwrite) BOOL					aacSelected;
//
@property (assign, readwrite) BOOL					nerryMoser44100;
@property (assign, readwrite) BOOL					nerryMoser22050;
@property (assign, readwrite) BOOL					nerryMoser11025;
@property (assign, readwrite) BOOL					nerryMoser8000;
@property (assign, readwrite) BOOL					nerryMoser5512;

@property (assign, readwrite) BOOL					mp3Stereo44100;
@property (assign, readwrite) BOOL					mp3Monoral44100;
@property (assign, readwrite) BOOL					mp3Stereo22050;
@property (assign, readwrite) BOOL					mp3Monoral22050;
@property (assign, readwrite) BOOL					mp3Stereo11025;
@property (assign, readwrite) BOOL					mp3Monoral11025;

@property (assign, readwrite) BOOL					aacCommonBitrate;
@property (assign, readwrite) BOOL					aacMonoral11025;
@property (assign, readwrite) BOOL					aacStereo8000;
@property (assign, readwrite) BOOL					aacMonoral8000;

#pragma mark - actions
- (IBAction) fmleProfileSelected:(NSPopUpButton *)sender;
- (IBAction) fmleSampleRateSelected:(NSPopUpButton *)sender;
- (IBAction) fmleFrameRateSelected:(NSPopUpButton *)sender;
- (IBAction) fmleEncodingFormatSelected:(NSPopUpButton *)sender;
- (IBAction) fmleInputSizeSelected:(NSPopUpButton *)sender;
- (IBAction) camTwistVideoSizeSelected:(NSPopUpButton *)sender;
- (IBAction) camTwistSaveConfig:(NSButton *)sender;

@end
