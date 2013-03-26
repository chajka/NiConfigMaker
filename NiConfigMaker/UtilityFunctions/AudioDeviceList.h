//
//  AudioDeviceList.h
//  common function
//
//  Created by Чайка on 10/28/12.
//  Copyright (c) 2012 iom. All rights reserved.
//

#include <CoreAudio/CoreAudio.h>

#ifndef Charleston_AudioDeviceList_h
#define Charleston_AudioDeviceList_h
// must required -fno-objc-arc
//	Modify Build Phase to
//	set -fno-objc-arc when using ARC at Complie Sources
//	Add CoreAudio.framework to Link Binary

#define DeviceUnitID		CFSTR("deviceUID")
#define	DeviceName			CFSTR("deviceName")
#define	DeviceManufacturer	CFSTR("deviceManufacturer")

/*
 kAudioDevicePropertyScopeInput          = 'inpt',
 kAudioDevicePropertyScopeOutput         = 'outp',
 kAudioDevicePropertyScopePlayThrough    = 'ptru',
*/
CFDictionaryRef CreateAudoiDeviceDict(AudioObjectPropertyScope deviceScope);

#endif
