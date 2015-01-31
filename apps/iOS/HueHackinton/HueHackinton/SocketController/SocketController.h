//
//  SocketController.h
//  HueHackinton
//
//  Created by Glenn Tillemans on 31-01-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//




#import <Foundation/Foundation.h>

#define SOCKET_URL @"hue-hackathon.pauldenotter.com"
#define SOCKET_PORT 8215

@interface SocketController : NSObject <NSStreamDelegate>

- (id)init;
- (void)send:(NSString *)input;


@end
