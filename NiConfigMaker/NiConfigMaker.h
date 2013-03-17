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
	IBOutlet NSComboBox				*comboboxTotalBitrate;
	BOOL							adjustBitrate;
		// FMLE Configure
	IBOutlet NSPopUpButton			*popupFMLEConfigureNames;
	IBOutlet NSTextField			*txtfldNewConfigureName;
	BOOL							syncFrameRate;
	BOOL							syncVideoSize;

		// CamTwist Settings
	IBOutlet NSTextField			*txtfldCamTwistFramerate;
	IBOutlet NSPopUpButton			*popupCamTwistVideoSize;
	BOOL							camTwistCustomVideoSize;
	IBOutlet NSTextField			*txtfldCamTwistCustomX;
	IBOutlet NSTextField			*txtfldCamTwistCustomY;

		// FMLE Audio Settings
	IBOutlet NSPopUpButton			*popupFMLEAudioInputDevice;
	IBOutlet NSPopUpButton			*popupFMLEAudioOutputFormat;
	IBOutlet NSPopUpButton			*popupFMLEAudioOutputChannel;
	IBOutlet NSPopUpButton			*popupFMLEAudioSamplerate;
	IBOutlet NSPopUpButton			*popupFMLEAudioBitrate;
	IBOutlet NSSlider				*popupFMLEAudioOutputVolume;

		// FMLE Video Settings
	IBOutlet NSPopUpButton			*popupFMLEVideoFramerate;
	IBOutlet NSPopUpButton			*popupFMLEVideoOutputFormat;
	IBOutlet NSPopUpButton			*popupFMLEVideoInputDeviceName;
	IBOutlet NSPopUpButton			*popupFMLEVideoInputSize;
	IBOutlet NSTextField			*txtfldFMLEVideoOutputSizeX;
	IBOutlet NSTextField			*txtfldFMLEVideoOutputSizeY;
	IBOutlet NSComboBox				*comboboxFMLEVideoOutputBitrate;

#pragma mark - program specific variables definitions
	NSArray							*audioDevices;
	NSArray							*videoDevides;
	NSPopUpButton *fmleSampleRateSelected;
}
@property (assign, readwrite) BOOL	adjustBitrate;
@property (assign, readwrite) BOOL	syncFrameRate;
@property (assign, readwrite) BOOL	syncVideoSize;
@property (assign, readwrite) BOOL	camTwistCustomVideoSize;

#pragma mark - actions
- (IBAction) fmleSampleRateSelected:(NSPopUpButton *)sender;
- (IBAction) fmleFrameRateSelected:(NSPopUpButton *)sender;
- (IBAction) fmleInputSizeSelected:(NSPopUpButton *)sender;
- (IBAction) camTwistVideoSizeSelected:(NSPopUpButton *)sender;
- (IBAction) camTwistSaveConfig:(NSButton *)sender;

@end
