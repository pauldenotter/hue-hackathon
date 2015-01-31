//
//  AudioControllerDelegate.h
//  HueHackinton
//
//  Created by Glenn Tillemans on 31-01-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AudioController;

@protocol AudioControllerDelegate <NSObject>

@required
- (void)audioRecognized:(AudioController *)recognizer;

@optional
- (void)audioLevelUpdated:(AudioController *)recognizer level:(float)lowPassResults;
- (void)audioLevelUpdated:(AudioController *)recognizer averagePower:(float)averagePower peakPower:(float)peakPower;

@end
