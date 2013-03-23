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

static NSInteger bitrateAACOffset = 0;
static NSInteger bitrateMP3Offset = 12;

@implementation NiConfigMaker (AudioBitrateMaskProperties)
- (NSIndexSet *) assignSamplrateStatus:(NSInteger)encodeType
{
	NSInteger encode = encodeType - KindAAC;
	self.samplerateStatus48000 = samplerateStateBitmap[encode][0];
	self.samplerateStatus44100 = samplerateStateBitmap[encode][1];
	self.samplerateStatus32000 = samplerateStateBitmap[encode][2];
	self.samplerateStatus22050 = samplerateStateBitmap[encode][3];
	self.samplerateStatus11025 = samplerateStateBitmap[encode][4];
	self.samplerateStatus8000  = samplerateStateBitmap[encode][5];
	self.samplerateStatus5512  = samplerateStateBitmap[encode][6];

	NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
	NSInteger index = 0;
	for (index = 0; index < SampleRateCount; index++)
		if (samplerateStateBitmap[encode][index] == NO)
			[indexes addIndex:index];
		// end if samplerate
	//end foreach status

	return [[[NSIndexSet alloc] initWithIndexSet:indexes] autorelease];
}// end - (void) assignSamplrateStatus:(NSInteger)tag

- (NSIndexSet *) assignBitrateStatuses:(NSInteger)encodeType channel:(NSInteger)channel
{
	NSInteger bitrate = (channel - KindStereo);
	NSInteger offset = bitrateMP3Offset;
	switch (encodeType)
	{
		case KindAAC:
			bitrate += (bitrateAACOffset + (audioSampleRateTag - SampleRate48000));
			break;
		case KindNellyMoser:
			switch (audioSampleRateTag)
			{
				case SampleRate5512:
					bitrate = 22;
					break;
				case SampleRate8000:
					bitrate = 21;
					break;
				case SampleRate11025:
					bitrate = 20;
					break;
				case SampleRate22050:
					bitrate = 19;
					break;
				case SampleRate44100:
				default:
					bitrate = 18;
					break;
			}// end case by
			break;
		case KindMP3:
		default:
			switch (audioSampleRateTag)
			{
				case SampleRate11025:
					offset += 4;
					break;
				case SampleRate22050:
					offset += 2;
					break;
				case SampleRate44100:
				default:
					offset += 0;
					break;
			}// end case by
			bitrate += offset;
			break;
	}// end case by encode type and stereo mode
	
	self.bitrateStatus320Kbps = bitrateStateBitmap[bitrate][0];
	self.bitrateStatus256Kbps = bitrateStateBitmap[bitrate][1];
	self.bitrateStatus224Kbps = bitrateStateBitmap[bitrate][2];
	self.bitrateStatus192Kbps = bitrateStateBitmap[bitrate][3];
	self.bitrateStatus160Kbps = bitrateStateBitmap[bitrate][4];
	self.bitrateStatus128Kbps = bitrateStateBitmap[bitrate][5];
	self.bitrateStatus112Kbps = bitrateStateBitmap[bitrate][6];
	self.bitrateStatus96Kbps  = bitrateStateBitmap[bitrate][7];
	self.bitrateStatus88Kbps  = bitrateStateBitmap[bitrate][8];
	self.bitrateStatus80Kbps  = bitrateStateBitmap[bitrate][9];
	self.bitrateStatus64Kbps  = bitrateStateBitmap[bitrate][10];
	self.bitrateStatus56Kbps  = bitrateStateBitmap[bitrate][11];
	self.bitrateStatus48Kbps  = bitrateStateBitmap[bitrate][12];
	self.bitrateStatus44Kbps  = bitrateStateBitmap[bitrate][13];
	self.bitrateStatus40Kbps  = bitrateStateBitmap[bitrate][14];
	self.bitrateStatus32Kbps  = bitrateStateBitmap[bitrate][15];
	self.bitrateStatus28Kbps  = bitrateStateBitmap[bitrate][16];
	self.bitrateStatus24Kbps  = bitrateStateBitmap[bitrate][17];
	self.bitrateStatus22Kbps  = bitrateStateBitmap[bitrate][18];
	self.bitrateStatus20Kbps  = bitrateStateBitmap[bitrate][19];
	self.bitrateStatus18Kbps  = bitrateStateBitmap[bitrate][20];
	self.bitrateStatus16Kbps  = bitrateStateBitmap[bitrate][21];
	self.bitrateStatus11Kbps  = bitrateStateBitmap[bitrate][22];

	NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
	NSInteger index = 0;
	for (index = 0; index < AudioBitrateCount; index++)
		if (bitrateStateBitmap[bitrate][index] == NO)
			[indexes addIndex:index];
		// end if samplerate
	//end foreach status
	
	return [[[NSIndexSet alloc] initWithIndexSet:indexes] autorelease];
}// end - (NSInteger) assignBitrateStatuses:(NSInteger)encodeType channel:(NSInteger)channel

@end
