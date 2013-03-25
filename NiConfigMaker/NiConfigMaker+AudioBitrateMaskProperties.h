//
//  NiConfigMaker+AudioBitrateMaskProperties.h
//  NiConfigMaker
//
//  Created by Чайка on 3/19/13.
//  Copyright (c) 2013 Instrumentality of mankind. All rights reserved.
//

#import "NiConfigMaker.h"
@interface NiConfigMaker (AudioBitrateMaskProperties)
- (NSIndexSet *) assignSamplrateByEncode:(NSInteger)encode;
- (NSIndexSet *) assignBitrateByEncode:(NSInteger)encode samplerate:(NSInteger)samplerate  channel:(NSInteger)channel;
@end
