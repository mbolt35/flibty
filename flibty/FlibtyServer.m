//
//  FlibtyServer.m
//  flibty
//
//  Created by Matt Bolt on 8/19/12.
//  Copyright (c) 2012 Matt Bolt. All rights reserved.
//

#import "FlibtyServer.h"

const NSUInteger POLICY_TAG = 10;

const NSString* const POLICY_FILE = @""
        "<?xml version=\"1.0\"?>\n"
        "<!DOCTYPE cross-domain-policy SYSTEM \"http://www.macromedia.com/xml/dtds/cross-domain-policy.dtd\">\n"
        "<cross-domain-policy>\n"
        "    <allow-access-from domain=\"*\" to-ports=\"*\" />\n"
        "</cross-domain-policy>\x00";

@implementation FlibtyServer

@synthesize socket;
@synthesize isRunning;

-(id)init {
    if ((self = [super init])) {
        socketQueue = dispatch_queue_create("socketQueue", NULL);
        socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:socketQueue];
        connectedSockets = [[NSMutableArray alloc] initWithCapacity:1];
        policyData = [POLICY_FILE dataUsingEncoding:NSUTF8StringEncoding];

        isRunning = NO;
    }

    return self;
}

-(void)start:(NSString*)host port:(int)port {
    if (isRunning) {
        NSLog(@"Server already running!");
        return;
    }
    if (![self isBetween:port min:0 max:65535]) {
        NSLog(@"Incorrect port value: %d - must be between 0 and 65535", port);
        return;
    }

    NSError* error = nil;
    if (![socket acceptOnInterface:host port:port error:&error]) {
        NSLog(@"Error starting server: %@", error);
        return;
    }

    NSLog(@"Server started on port %hu", [socket localPort]);
    isRunning = YES;
}

-(void)stop {
    if (!isRunning) {
        NSLog(@"Server is not running. Nothing to stop");
        return;
    }

    [socket disconnect];

    // Stop any client connections
    @synchronized (connectedSockets) {
        NSUInteger i;
        for (i = 0; i < connectedSockets.count; i++) {
            [[connectedSockets objectAtIndex:i] disconnect];
        }
    }


    isRunning = NO;
}

-(void)socket:(GCDAsyncSocket*)sock didAcceptNewSocket:(GCDAsyncSocket*)newSocket {
    @synchronized (connectedSockets) {
        [connectedSockets addObject:newSocket];
    }

    NSString* host = [newSocket connectedHost];
    UInt16 port = [newSocket connectedPort];

    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
            NSLog(@"Accepted client %@:%hu", host, port);
        }
    });

    [newSocket readDataToData:[GCDAsyncSocket ZeroData] withTimeout:-1 tag:0];
}

-(void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag {
    if (tag == POLICY_TAG) {
        [sock readDataToData:[GCDAsyncSocket ZeroData] withTimeout:-1 tag:0];
    }
}

-(void)socket:(GCDAsyncSocket*)sock didReadData:(NSData*)data withTag:(long)tag {
    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
            NSData* strData = [data subdataWithRange:NSMakeRange(0, data.length - 1)];
            NSString* msg = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];

            if (msg) {
                if ([msg rangeOfString:@"policy-file-request"].location != NSNotFound) {
                    NSLog(@"Policy file requested, serving.");
                    [sock writeData:policyData withTimeout:-1 tag:POLICY_TAG];
                } else {
                    NSRange range = [msg rangeOfString:@"!SOS"];

                    if (range.location != NSNotFound) {
                        NSString* xmlString = [msg substringFromIndex:range.location + range.length];

                        [XML loadXmlString:xmlString onLoadComplete:^(XML* xml) {
                            @autoreleasepool {
                                NSLog(@"key: %@, value: %@", [xml attributeByName:@"key"], xml.nodeValue);
                            }
                        }];
                    }

                    // Queue next read
                    [sock readDataToData:[GCDAsyncSocket ZeroData] withTimeout:-1 tag:0];
                }
            } else {
                NSLog(@"Error converting received data into UTF-8 String");
            }
        }
    });
}

-(void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err {
    if (sock != socket) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @autoreleasepool {
                NSLog(@"client disconnected, error: %@", err);
            }
        });

        @synchronized (connectedSockets) {
            [connectedSockets removeObject:sock];
        }
    }
}

/**
 * @private
 * ensures a range
 */
-(BOOL)isBetween:(int)value min:(int)min max:(int)max {
    return value >= min && value <= max;
}

@end
