//
//  NiConfigMakerDefinitions.h
//  NiConfigMaker
//
//  Created by Чайка on 3/16/13.
//  Copyright (c) 2013 Instrumentality of mankind. All rights reserved.
//
#pragma once

#ifndef NiConfigMaker_NiConfigMakerDefinitions_h
#define NiConfigMaker_NiConfigMakerDefinitions_h
	// common definiton
#define EmptyString						@""
#define VideoSizeSeparatorString		@"x"
#define VideoSizeConstructFormat		@"%@x%@"
#define PathSeparatorString				@"/"

	// FMLE definition
#define AdobeConfigureationPath			@"~/Library/Application Support/Adobe/"
#define FMLEProfileFolderPrefix			@"Flash Media Live Encoder"
#define FMLEProfilePath					@"~/Library/Application Support/Adobe/Flash Media Live Encoder 3.2"
#define FMLEProfileExtension			@"xml"
#define FMLEDefalutProfileName			@"startup"

#define FMLEVideoDeviceXPath			@"/flashmedialiveencoder_profile/capture/video/device"						//
#define FMLEVideoFrameRateXPath			@"/flashmedialiveencoder_profile/capture/video/frame_rate"					//
#define FMLEVideoFrameWidthXPath		@"/flashmedialiveencoder_profile/capture/video/size/width"					//
#define FMLEVideoFrameHeightXPath		@"/flashmedialiveencoder_profile/capture/video/size/height"					//
#define FMLEAudioDeviceNameXPath		@"/flashmedialiveencoder_profile/capture/audio/device"						//
#define FMLEAudioSampleRateXPath		@"/flashmedialiveencoder_profile/capture/audio/sample_rate"					//
#define FMLEAudioInputVolumeXPath		@"/flashmedialiveencoder_profile/capture/audio/input_volume"				//
#define FMLEAudioChannelsXPath			@"/flashmedialiveencoder_profile/capture/audio/channels"					//
#define FMLEVideoKeepAspectXPath		@"/flashmedialiveencoder_profile/process/video/preserve_aspect"				//
#define FMLEEncodeFormatNameXPath		@"/flashmedialiveencoder_profile/encode/video/format"						//
#define FMLEEncodeDataRateXPath			@"/flashmedialiveencoder_profile/encode/video/datarate"						//
#define FMLEEncodeOutputSizeXPath		@"/flashmedialiveencoder_profile/encode/video/outputsize"
#define FMLEAdvancedVP6KeyFrameXPath	@"/flashmedialiveencoder_profile/encode/video/advanced/keyframe_frequency"	//
#define FMLEAdvancedVP6QualityXPath		@"/flashmedialiveencoder_profile/encode/video/advanced/quality"			//
#define FMLEAdvancedVP6NRXpath			@"/flashmedialiveencoder_profile/encode/video/advanced/noise_reduction"	//
#define FMLEAdvancedVP6DatarateXpath	@"/flashmedialiveencoder_profile/encode/video/advanced/datarate_window"	//
#define FMLEAdvancedVP6CPUUseage		@"/flashmedialiveencoder_profile/encode/video/advanced/cpu_usage"
#define FMLEAdvancedH264ProfileXPath	@"/flashmedialiveencoder_profile/encode/video/advanced/profile"
#define FMLEAdvancedH264LevelXPath		@"/flashmedialiveencoder_profile/encode/video/advanced/level"
#define FMLEAdvancedH264KeyFrameXPath	@"/flashmedialiveencoder_profile/encode/video/advanced/keyframe_frequency"
#define FMLEEncodeAudioFormatXPath		@"/flashmedialiveencoder_profile/encode/audio/format"						//
#define FMLEEncodeAudioDataRateXPath	@"/flashmedialiveencoder_profile/encode/audio/datarate"						//
#define FMLEDatarateOutputSizeFormat	@"%@;"

	// CamTwist definition
#define CamTwistConfigFilePath			@"~/Library/Preferences/com.allocinit.CamTwist.plist"

	// boolean must be false
#define CamTwistKeyDriverSetting		@"dontLoadDriverUnlessAppRunning"
// NSInteger frame rate
#define CamTwistKeyFrameRate			@"frameRate"
	// boolean virtualDriver
#define CamTwistKeyVirtualDriver		@"noVirtualDriver"
	// boolean use custom video size
#define CamTwistKeyCustomVideoSize		@"usingCustomVideoSize"
	// string video frame size
#define CamTwistKeyVideoSize			@"videoSize"
#define CamTwistVideSizeFormat			@"{%@, %@}"

typedef NSInteger FMLEVideoFormatKind;
enum FMLEVideoFormatKind {
	KindH264 = 1001,
	KindVP6
};// end enum FMLEVideoFormatKind

typedef NSInteger FMLEAudioFormatKind;
enum FMLEAudioFormatKind {
	KindAAC = 0,
	KindMP3,
	KindNellyMoser
};// end enum FMLEAudioFormatKind

typedef NSInteger SampleRate;
enum SampleRate {
	SampleRate48000 = 1001,
	SampleRate44100,
	SampleRate32000,
	SampleRate22050,
	SampleRate11025,
	SampleRate8500,
	SampleRate5512
};// end enum SampleRate

typedef NSInteger VideoSize;
enum VideoSize {
	VideoSize88x72 = 1001,
	VideoSize128x96,
	VideoSize160x80,
	VideoSize160x120,
	VideoSize160x240,
	VideoSize176x144,
	VideoSize240x176,
	VideoSize240x180,
	VideoSize256x192,
	VideoSize320x180,
	VideoSize320x192,
	VideoSize320x240,
	VideoSize352x240,
	VideoSize352x288,
	VideoSize384x288,
	VideoSize480x288,
	VideoSize480x360,
	VideoSize640x240,
	VideoSize640x288,
	VideoSize640x360,
	VideoSize640x480,
	VideoSize648x486,
	VideoSize704x480,
	VideoSize704x576,
	VideoSize720x240,
	VideoSize720x288,
	VideoSize720x380,
	VideoSize720x400,
	VideoSize720x480,
	VideoSize720x576,
	VideoSize768x576,
	VideoSize1024x768,
	VideoSize1024x1080,
	VideoSize1280x720,
	VideoSize1280x1080,
	VideoSize1920x1080
};// end enum VideoSize

typedef NSInteger FrameRate;
enum FrameRate {
	FrameRate60_00,
	FrameRate59_94,
	FrameRate30_00,
	FrameRate29_97,
	FrameRate25_00,
	FrameRate24_00,
	FrameRate20_00,
	FrameRate15_00,
	FrameRate14_98,
	FrameRate10_00,
	FrameRate08_00,
	FrameRate06_00,
	FrameRate05_00,
	FrameRate04_00,
	FrameRate01_00
};// end enum FrameRate

typedef NSInteger AudioBitRate;
enum AudioBitRate {
	AudioBitRate224,
	AudioBitRate192,
	AudioBitRate160,
	AudioBitRate128,
	AudioBitRate112,
	AudioBitRate96,
	AudioBitRate64,
	AudioBitRate56,
	AudioBitRate48,
	AudioBitRate40,
	AudioBitRate32,
	AudioBitRate24,
	AudioBitRate20,
	AudioBitRate18
};// end enum AudioBitRate

#endif
