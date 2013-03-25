//
//  NiConfigMaker+AudioBitrateMaskProperties.m
//  NiConfigMaker
//
//  Created by Чайка on 3/19/13.
//  Copyright (c) 2013 Instrumentality of mankind. All rights reserved.
//

#import "NiConfigMakerDefinitions.h"
#import "NiConfigMaker+AudioBitrateMaskProperties.h"

static BOOL samplerateStateBitmap[3][7] = {
	{ NO , NO , NO , NO , NO , NO , YES }, 		// AAC
	{ YES, NO , YES, NO , NO , YES, YES }, 		// MP3
	{ YES, NO , YES, NO , NO , NO , NO  }		// NerryMoser
};// end static BOOL samplerateStateBitmap[3][7]


static BOOL bitrateStateBitmap[23][23] = {
/*	  320  256  224  192  160  128  112   96   88   80   64   56   48   44   40   32   28   24   22   20   18   16   11  */
	{ NO,  NO,  NO,  NO,  NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  YES, NO,  YES  },	// 00 AAC Stereo	48000:(BOOL)bitrate
	{ NO,  NO,  NO,  NO,  NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  YES, NO,  YES  },	// 01 AAC Monoral	48000:(BOOL)bitrate
	{ NO,  NO,  NO,  NO,  NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  YES, NO,  YES  },	// 02 AAC Stereo	44100:(BOOL)bitrate
	{ NO,  NO,  NO,  NO,  NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  YES, NO,  YES  },	// 03 AAC Monoral	44100:(BOOL)bitrate
	{ NO,  NO,  NO,  NO,  NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  YES, NO,  YES  },	// 04 AAC Stereo	32000:(BOOL)bitrate
	{ NO,  NO,  NO,  NO,  NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  YES, NO,  YES  },	// 05 AAC Monoral	32000:(BOOL)bitrate
	{ NO,  NO,  NO,  NO,  NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  YES, NO,  YES  },	// 06 AAC Stereo	22050:(BOOL)bitrate
	{ NO,  NO,  NO,  NO,  NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  YES, NO,  YES  },	// 07 AAC Monoral	22050:(BOOL)bitrate
	{ NO,  NO,  NO,  NO,  NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  YES, NO,  YES  },	// 08 AAC Stereo	11025:(BOOL)bitrate
	{ YES, YES, YES, YES, NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  YES, NO,  YES  },	// 09 AAC Monoral	11025:(BOOL)bitrate
	{ YES, NO,  NO,  NO,  NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  YES, NO,  YES  },	// 10 AAC Stereo	 8000:(BOOL)bitrate
	{ YES, YES, YES, YES, YES, NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  NO,  YES, NO,  YES, NO,  YES  },	// 11 AAC Monoral	 8000:(BOOL)bitrate
/*	  320  256  224  192  160  128  122   96   88   80   64   56   48   44   40   32   28   24   22   20   18   16   11  */
	{ YES, YES, NO,  NO,  NO,  NO,  NO,  NO,  YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES  },	// 12 MP3 Stereo	44100:(BOOL)bitrate
	{ YES, YES, NO,  NO,  NO,  NO,  NO,  NO,  YES, NO,  NO,  NO,  YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES  },	// 13 MP3 Monoral	44100:(BOOL)bitrate
	{ YES, YES, YES, YES, YES, YES, YES, YES, YES, NO,  NO,  NO,  NO,  YES, NO,  YES, YES, YES, YES, YES, YES, YES, YES  },	// 14 MP3 Stereo	22050:(BOOL)bitrate
	{ YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, NO,  YES, NO,  NO,  YES, YES, YES, YES, YES, YES, YES  },	// 15 MP3 Monoral	22050:(BOOL)bitrate
	{ YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, NO,  YES, NO,  YES, NO,  YES, YES, YES  },	// 16 MP3 Stereo	11025:(BOOL)bitrate
	{ YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, NO,  NO,  YES, YES  },	// 17 MP3 Monoral	11025:(BOOL)bitrate
/*	  320  256  224  192  160  128  122   96   88   80   64   56   48   44   40   32   28   24   22   20   18   16   11  */
	{ YES, YES, YES, YES, YES, YES, YES, YES, NO,  YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES  },	// 18 NellyMoser	44100:(BOOL)bitrate
	{ YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, NO,  YES, YES, YES, YES, YES, YES, YES, YES, YES  },	// 19 NellyMoser	22050:(BOOL)bitrate
	{ YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, NO,  YES, YES, YES, YES  },	// 20 NellyMoser	11025:(BOOL)bitrate
	{ YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, NO,  YES  },	// 21 NellyMoser	 8000:(BOOL)bitrate
	{ YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, YES, NO   }	// 22 NellyMoser	 5512:(BOOL)bitrate
};// end static BOOL bitrateStateBitmap[23][20]

	//static NSInteger bitrateAACOffset = 0;
static NSInteger bitrateMP3Offset = 12;
	//static NSInteger bitrateNerriNoserOffset = 18;

@implementation NiConfigMaker (AudioBitrateMaskProperties)
- (NSIndexSet *) assignSamplrateByEncode:(NSInteger)encode
{
	if (encode < KindH264)
		encode = KindVP6;

	NSInteger mode = encode - KindAAC;
	self.samplerateStatus48000 = samplerateStateBitmap[mode][0];
	self.samplerateStatus44100 = samplerateStateBitmap[mode][1];
	self.samplerateStatus32000 = samplerateStateBitmap[mode][2];
	self.samplerateStatus22050 = samplerateStateBitmap[mode][3];
	self.samplerateStatus11025 = samplerateStateBitmap[mode][4];
	self.samplerateStatus8000  = samplerateStateBitmap[mode][5];
	self.samplerateStatus5512  = samplerateStateBitmap[mode][6];

	NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
	NSInteger index = 0;
	for (index = 0; index < SampleRateCount; index++)
		if (samplerateStateBitmap[mode][index] == NO)
			[indexes addIndex:(index + SampleRate48000)];
		// end if samplerate
	//end foreach status

	return indexes;
}// end - (void) assignSamplrateStatus:(NSInteger)tag

- (NSIndexSet *) assignBitrateByEncode:(NSInteger)encode samplerate:(NSInteger)samplerate  channel:(NSInteger)channel
{
	if (encode < KindAAC)				encode = KindMP3;
	if (samplerate < SampleRate48000)	samplerate = SampleRate44100;
	if (channel < KindStereo)			channel = KindMonoral;

	NSInteger mode = 0;
	switch (encode) {
		case KindNellyMoser:
			switch (samplerate)
			{
				case SampleRate5512:
					mode = 22;
					break;
				case SampleRate8000:
					mode = 21;
					break;
				case SampleRate11025:
					mode = 20;
					break;
				case SampleRate22050:
					mode = 19;
					break;
				case SampleRate44100:
				default:
					mode = 18;
					break;
			}// end case by NerryMoser’s sample rate
			break;
		case KindMP3:
			switch (samplerate)
		{
			case SampleRate44100:
				mode = (channel - KindStereo) + bitrateMP3Offset;
				break;
			case SampleRate22050:
				mode = 2 + (channel - KindStereo) + bitrateMP3Offset;
				break;
			case SampleRate11025:
			default:
				mode = 4 + (channel - KindStereo) + bitrateMP3Offset;
				break;
		}// end case by MP3’s sample rate
			break;
		case KindAAC:
		default:
			mode = ((samplerate - SampleRate48000) * 2) + (channel - KindStereo);
			break;
	}// end case by audio encode (output) format

	self.bitrateStatus320Kbps = bitrateStateBitmap[mode][0];
	self.bitrateStatus256Kbps = bitrateStateBitmap[mode][1];
	self.bitrateStatus224Kbps = bitrateStateBitmap[mode][2];
	self.bitrateStatus192Kbps = bitrateStateBitmap[mode][3];
	self.bitrateStatus160Kbps = bitrateStateBitmap[mode][4];
	self.bitrateStatus128Kbps = bitrateStateBitmap[mode][5];
	self.bitrateStatus112Kbps = bitrateStateBitmap[mode][6];
	self.bitrateStatus96Kbps  = bitrateStateBitmap[mode][7];
	self.bitrateStatus88Kbps  = bitrateStateBitmap[mode][8];
	self.bitrateStatus80Kbps  = bitrateStateBitmap[mode][9];
	self.bitrateStatus64Kbps  = bitrateStateBitmap[mode][10];
	self.bitrateStatus56Kbps  = bitrateStateBitmap[mode][11];
	self.bitrateStatus48Kbps  = bitrateStateBitmap[mode][12];
	self.bitrateStatus44Kbps  = bitrateStateBitmap[mode][13];
	self.bitrateStatus40Kbps  = bitrateStateBitmap[mode][14];
	self.bitrateStatus32Kbps  = bitrateStateBitmap[mode][15];
	self.bitrateStatus28Kbps  = bitrateStateBitmap[mode][16];
	self.bitrateStatus24Kbps  = bitrateStateBitmap[mode][17];
	self.bitrateStatus22Kbps  = bitrateStateBitmap[mode][18];
	self.bitrateStatus20Kbps  = bitrateStateBitmap[mode][19];
	self.bitrateStatus18Kbps  = bitrateStateBitmap[mode][20];
	self.bitrateStatus16Kbps  = bitrateStateBitmap[mode][21];
	self.bitrateStatus11Kbps  = bitrateStateBitmap[mode][22];

	NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
	NSInteger index = 0;
	for (index = 0; index < AudioBitrateCount; index++)
		if (bitrateStateBitmap[mode][index] == NO)
			[indexes addIndex:(index + AudioBitRate320)];
		// end if samplerate
	//end foreach status
	
	return [[[NSIndexSet alloc] initWithIndexSet:indexes] autorelease];
}// end - (NSInteger) assignBitrateStatuses:(NSInteger)encodeType channel:(NSInteger)channel

@end
