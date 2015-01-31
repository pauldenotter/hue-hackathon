//
//  AudioController.h
//  HueHackinton
//
//  Created by Glenn Tillemans on 31-01-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "AudioControllerDelegate.h"

#define AUDIO_RECOGNIZER_SENSITIVITY_LOW 0.90f
#define AUDIO_RECOGNIZER_SENSITIVITY_MODERATE 0.70f
#define AUDIO_RECOGNIZER_SENSITIVITY_HIGH 0.50f
#define AUDIO_RECOGNIZER_SENSITIVITY_DEFAULT AUDIO_RECOGNIZER_SENSITIVITY_MODERATE

#define AUDIO_RECOGNIZER_FREQUENCY_LOW 0.1f
#define AUDIO_RECOGNIZER_FREQUENCY_MODERATE 0.03f
#define AUDIO_RECOGNIZER_FREQUENCY_HIGH 0.02f
#define AUDIO_RECOGNIZER_FREQUENCY_DEFAULT AUDIO_RECOGNIZER_FREQUENCY_MODERATE

@interface AudioController : NSObject

@property (nonatomic, weak) id <AudioControllerDelegate> delegate;
@property (nonatomic, readonly) float sensitivity;
@property (nonatomic, readonly) float frequency;
@property (nonatomic, readonly) float lowPassResults;

- (id)initWithSensitivity:(float)sensitivity frequency:(float)frequency;
