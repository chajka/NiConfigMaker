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

typedef NSInteger SampleRate;
enum SampleRate {
	SampleRate22050,
	SampleRate11025,
	SampleRate8500,
	SampleRate5512
};// end enum SampleRate

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
