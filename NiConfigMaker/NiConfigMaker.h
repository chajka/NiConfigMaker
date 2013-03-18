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
	IBOutlet NSPopUpButton							*popupVP6KeyframeFrequency;
	IBOutlet NSPopUpButton							*popupVP6Quqlity;
	IBOutlet NSPopUpButton							*popupVP6NoiseReduction;
	IBOutlet NSPopUpButton							*popupVP6DatarateWindow;
	IBOutlet NSPopUpButton							*popupVP6CPUUseage;
		// Settings for H.264
	IBOutlet NSPopUpButton							*popupH264Profile;
	IBOutlet NSPopUpButton							*popupH264Level;
	IBOutlet NSPopUpButton							*popupH264KeyframeFrequency;
	BOOL											aacSelected;
	

#pragma mark - program specific variables definitions
@protected
	NSArray											*audioDevices;
	NSArray											*videoDevides;
	NSArray											*fmleProfiles;
	NSString										*fmleProfilePath;
	NSXMLDocument									*currentFMLEProfile;
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
@property (assign, readwrite) BOOL					aacSelected;

#pragma mark - actions
- (IBAction) fmleSampleRateSelected:(NSPopUpButton *)sender;
- (IBAction) fmleFrameRateSelected:(NSPopUpButton *)sender;
- (IBAction) fmleEncodingFormatSelected:(NSPopUpButton *)sender;
- (IBAction) fmleInputSizeSelected:(NSPopUpButton *)sender;
- (IBAction) camTwistVideoSizeSelected:(NSPopUpButton *)sender;
- (IBAction) camTwistSaveConfig:(NSButton *)sender;

@end
