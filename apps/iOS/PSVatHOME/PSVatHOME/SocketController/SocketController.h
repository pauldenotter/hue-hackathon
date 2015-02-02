//
//  SocketController.h
//  HueHackinton
//
//  Created by Glenn Tillemans on 31-01-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SocketController;

@protocol SocketControllerDelegate <NSObject>

@required
- (void)message:(NSString *)message;

@end

#define SOCKET_URL @"hue-hackathon.pauldenotter.com"
#define SOCKET_PORT 1230

@interface SocketController : NSObject <NSStreamDelegate>

@property (nonatomic, weak) id <SocketControllerDelegate> delegate;

- (id)init;
- (void)open;
- (void)close;
- (void)send:(NSString *)input;


@end
