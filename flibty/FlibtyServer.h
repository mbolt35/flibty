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

extern const NSUInteger POLICY_TAG;
extern const NSString* const POLICY_FILE;

@interface FlibtyServer : NSObject {
    GCDAsyncSocket* socket;
    NSData* policyData;
    NSMutableArray* connectedSockets;
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
-(BOOL)isBetween:(int)value min:(int)min max:(int)max;
@end
