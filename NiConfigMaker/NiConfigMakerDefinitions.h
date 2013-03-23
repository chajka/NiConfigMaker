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
#define PathSeparatorString				@"/"
#define VideoSizeConstructFormat		@"%@x%@"
#define FMLEDatarateOutputSizeFormat	@"%@;"

	// FMLE definition
#define AdobeConfigureationPath			@"~/Library/Application Support/Adobe/"
#define FMLEProfileFolderPrefix			@"Flash Media Live Encoder"
#define FMLEProfilePath					@"~/Library/Application Support/Adobe/Flash Media Live Encoder 3.2"
#define FMLEProfileExtension			@"xml"
#define FMLEDefalutProfileName			@"startup"

#define FMLECaptureVideoDevice			@"/flashmedialiveencoder_profile/capture/video/device"						//
#define FMLECaptureVideoFrameRate		@"/flashmedialiveencoder_profile/capture/video/frame_rate"					//
#define FMLECaptureVideoFrameWidth		@"/flashmedialiveencoder_profile/capture/video/size/width"					//
#define FMLECaptureVideoFrameHeight		@"/flashmedialiveencoder_profile/capture/video/size/height"					//

#define FMLECaptureAudioDeviceName		@"/flashmedialiveencoder_profile/capture/audio/device"						//
#define FMLECaptureAudioSampleRate		@"/flashmedialiveencoder_profile/capture/audio/sample_rate"					//
#define FMLECaptureAudioChannels		@"/flashmedialiveencoder_profile/capture/audio/channels"					//
#define FMLECaptureAudioInputVolume		@"/flashmedialiveencoder_profile/capture/audio/input_volume"				//

#define FMLEProcessVideoPreserveAspect	@"/flashmedialiveencoder_profile/process/video/preserve_aspect"				//

#define FMLEEncodeVideoFormatName		@"/flashmedialiveencoder_profile/encode/video/format"						//
#define FMLEEncodeVideoDataRate			@"/flashmedialiveencoder_profile/encode/video/datarate"						//
#define FMLEEncodeVideoOutputSize		@"/flashmedialiveencoder_profile/encode/video/outputsize"

#define FMLEAdvancedVideoVP6KeyFrame	@"/flashmedialiveencoder_profile/encode/video/advanced/keyframe_frequency"	//
#define FMLEAdvancedVP6Quality			@"/flashmedialiveencoder_profile/encode/video/advanced/quality"			//
#define FMLEAdvancedVideoVP6NRXpath		@"/flashmedialiveencoder_profile/encode/video/advanced/noise_reduction"	//
#define FMLEAdvancedVideoVP6Datarate	@"/flashmedialiveencoder_profile/encode/video/advanced/datarate_window"	//
#define FMLEAdvancedVideoVP6CPUUseage	@"/flashmedialiveencoder_profile/encode/video/advanced/cpu_usage"
#define FMLEAdvancedH264Profile			@"/flashmedialiveencoder_profile/encode/video/advanced/profile"
#define FMLEAdvancedVideoH264Level		@"/flashmedialiveencoder_profile/encode/video/advanced/level"
#define FMLEAdvancedH264KeyFrame		@"/flashmedialiveencoder_profile/encode/video/advanced/keyframe_frequency"
#define FMLEEncodeAudioFormat			@"/flashmedialiveencoder_profile/encode/audio/format"						//
#define FMLEEncodeAudioDataRate			@"/flashmedialiveencoder_profile/encode/audio/datarate"						//

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

		// Video encode format
#define EncodeTypeH264					@"H.264"
#define EncodeTypeVP6					@"VP6"
typedef NSInteger FMLEVideoFormatValue;
enum FMLEVideoFormatValue {
	KindH264 = 1001,
	KindVP6
};// end enum FMLEVideoFormatKind

		// Audio encode format
#define EncodeTypeAAC					@"AAC"
#define EncodeTypeMP3					@"MP3"
#define EncodeTypeNerryMoser			@"NerryMoser"
typedef NSInteger FMLEAudioFormatValue;
enum FMLEAudioFormatValue {
	KindAAC = 1001,
	KindMP3,
	KindNellyMoser,
};// end enum FMLEAudioFormatKind


	// Channel type string
#define ChannelStereo					@"Stereo"
#define ChannelMonoral					@"Mono"
typedef NSInteger AudioChannelValue;
enum AudioChannelValue {
	KindStereo = 1001,
	KindMonoral
};

typedef NSInteger SampleRateValue;
enum SampleRateValue {
	SampleRate48000 = 1001,
	SampleRate44100,
	SampleRate32000,
	SampleRate22050,
	SampleRate11025,
	SampleRate8000,
	SampleRate5512
};// end enum SampleRate
#define SampleRateCount					(7)

typedef NSInteger AudioBitRateValue;
enum AudioBitRateValue {
	AudioBitRate320 = 1001,
	AudioBitRate256,
	AudioBitRate224,
	AudioBitRate192,
	AudioBitRate160,
	AudioBitRate128,
	AudioBitRate112,
	AudioBitRate96,
	AudioBitRate88,
	AudioBitRate80,
	AudioBitRate64,
	AudioBitRate56,
	AudioBitRate48,
	AudioBitRate44,
	AudioBitRate40,
	AudioBitRate32,
	AudioBitRate28,
	AudioBitRate24,
	AudioBitRate22,
	AudioBitRate20,
	AudioBitRate18,
	AudioBitRate16,
	AudioBitRate11
};// end enum AudioBitRate
#define AudioBitrateCount				(23)

typedef NSInteger VideoSizeValue;
enum VideoSizeValue {
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

typedef NSInteger FrameRateValue;
enum FrameRateValue {
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

#endif
