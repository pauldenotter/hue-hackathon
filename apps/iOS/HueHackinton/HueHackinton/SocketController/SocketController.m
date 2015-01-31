//
//  SocketController.m
//  HueHackinton
//
//  Created by Glenn Tillemans on 31-01-15.
//  Copyright (c) 2015 Magneds B.V. All rights reserved.
//

#import "SocketController.h"

@implementation SocketController

CFReadStreamRef readStream;
CFWriteStreamRef writeStream;

NSInputStream *inputStream;
NSOutputStream *outputStream;

- (id)init
{

    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)SOCKET_URL, SOCKET_PORT, &readStream, &writeStream);
    inputStream = (NSInputStream *)CFBridgingRelease(readStream);
    outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);
    
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    return self;
}

- (void)open
{
    [inputStream open];
    [outputStream open];
}

- (void)close
{
    [inputStream close];
    [outputStream close];
}

- (void)send:(NSString *)input
{
    NSData *data = [[NSData alloc] initWithData:[input dataUsingEncoding:NSUTF8StringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}

@end
