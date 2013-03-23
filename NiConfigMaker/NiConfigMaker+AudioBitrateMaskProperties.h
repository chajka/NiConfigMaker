//
//  NiConfigMaker+AudioBitrateMaskProperties.h
//  NiConfigMaker
//
//  Created by Чайка on 3/19/13.
//  Copyright (c) 2013 Instrumentality of mankind. All rights reserved.
//

#import "NiConfigMaker.h"
@interface NiConfigMaker (AudioBitrateMaskProperties)
- (NSIndexSet *) assignSamplrateStatus:(NSInteger)encodeType;
- (NSIndexSet *) assignBitrateStatuses:(NSInteger)encodeType channel:(NSInteger)channel;
@end
