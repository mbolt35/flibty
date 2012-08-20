//
//  FlibtyServer.h
//  flibty
//
//  Created by Matt Bolt on 8/19/12.
//  Copyright (c) 2012 Matt Bolt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "XML.h"

#define POLICY_TAG 10
#define POLICY_FILE @"<?xml version=\"1.0\"?>\n<!DOCTYPE cross-domain-policy SYSTEM \"http://www.macromedia.com/xml/dtds/cross-domain-policy.dtd\">\n<cross-domain-policy>\n    <allow-access-from domain=\"*\" to-ports=\"*\" />\n</cross-domain-policy>\x00"

@interface FlibtyServer : NSObject {
    GCDAsyncSocket* socket;
    NSMutableArray *connectedSockets;
    dispatch_queue_t socketQueue;
    
    BOOL isRunning;
}

-(void)start:(NSString*)host port:(int)port;
-(void)stop;

@property(readonly, nonatomic) GCDAsyncSocket* socket;
@property(readonly, nonatomic) BOOL isRunning;

@end

/**
 * @private
 * the private methods interface
 */
@interface FlibtyServer (private)
- (BOOL)isBetween:(int)value min:(int)min max:(int)max;
@end
