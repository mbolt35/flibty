////////////////////////////////////////////////////////////////////////////////
//
//  MATTBOLT.BLOGSPOT.COM
//  Copyright(C) 2012 Matt Bolt
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at:
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "FlibtyConnectionDelegate.h"
#import "LogTargetDelegate.h"
#import "GCDAsyncSocket.h"
#import "XML.h"
#import "FlibtyHelper.h"

@protocol LogTargetFactory;

@interface FlibtyServer : NSObject<FlibtyConnectionDelegate, LogTargetDelegate> {
    GCDAsyncSocket* socket;
    NSMutableDictionary* connectedSockets;
    id<LogTargetFactory> logFactory;
    dispatch_queue_t socketQueue;

    BOOL isRunning;
}

/**
 * This method initializes the FlibtyServer using a LogTargetFactory implementation.
 */
-(id)initWith:(id<LogTargetFactory>)loggerFactory;

/**
 * This method starts the FlibtyServer on a specific host and port.
 */
-(void)start:(NSString*)host port:(int)port;

/**
 * This method disconnects all connected clients and shuts down the server.
 */
-(void)stop;

//@property(readonly, nonatomic) GCDAsyncSocket* socket;
@property(readwrite, nonatomic) id<LogTargetFactory> logFactory;
@property(readonly, nonatomic) BOOL isRunning;

@end


// private category
@interface FlibtyServer (private)
-(BOOL)isBetween:(int)value min:(int)min max:(int)max;
@end
