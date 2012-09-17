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

#import "FlibtyServer.h"
#import "FlibtyConnection.h"
#import "LogTarget.h"
#import "LogTargetFactory.h"
#import "SOSLogParser.h"

@implementation FlibtyServer {
    NSMutableDictionary* attempts;
}

@synthesize logFactory;
@synthesize isRunning;

-(id)init {
    if ((self = [super init])) {
        socketQueue = dispatch_queue_create("socketQueue", NULL);
        socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:socketQueue];
        connectedSockets = [[NSMutableDictionary alloc] initWithCapacity:1];
        attempts = [[NSMutableDictionary alloc] initWithCapacity:1];

        isRunning = NO;
    }

    return self;
}

-(id)initWith:(id<LogTargetFactory>)loggerFactory {
    if (self = [self init]) {
        logFactory = loggerFactory;
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
    if (![socket acceptOnInterface:host port:(uint16_t)port error:&error]) {
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
        for (NSString* key in connectedSockets.allKeys) {
            [connectedSockets[key] disconnect];
        }
    }

    isRunning = NO;
}

-(void)socket:(GCDAsyncSocket*)sock didAcceptNewSocket:(GCDAsyncSocket*)newSocket {
    FlibtyConnection* connection = [[FlibtyConnection alloc]
        initWithDelegate:self
        socket:newSocket
        parsedWith:[[SOSLogParser alloc] init]];

    @synchronized(attempts) {
        attempts[connection.key] = connection;
    }
}

-(void)socketDidConnect:(FlibtyConnection*)connection {
    @synchronized (connectedSockets) {
        connectedSockets[connection.key] = connection;
    }
    @synchronized (attempts) {
        [attempts removeObjectForKey:connection.key];
    }
    
    id<LogTarget> logTarget = [logFactory newLogTarget:connection.key];
    if (logTarget && [logTarget respondsToSelector:@selector(setDelegate:)]) {
        logTarget.delegate = self;
    }
    connection.logTarget = logTarget;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Accepted client: %@", connection.key);
    });
}

-(void)socketDisconnected:(FlibtyConnection*)connection {
    // This is the behavior post policy file acceptance, or if the client never successfully
    // sent a valid log.
    @synchronized(attempts) {
        if (attempts[connection.key]) {
            [attempts removeObjectForKey:connection.key];
            return;
        }
    }
    
    [connectedSockets removeObjectForKey:connection.key];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Removed client connection for key: %@ - %lu connections remaining.", connection.key, connectedSockets.count);
    });
}

-(void)onTargetClosed:(id<LogTarget>)target {
    NSLog(@"Disconnecting client: %@", target.name);
    
    if (connectedSockets[target.name]) {
        [connectedSockets[target.name] disconnect];
    }
}

/**
 * @private
 * ensures a range -- TODO: NSRange?
 */
-(BOOL)isBetween:(int)value min:(int)min max:(int)max {
    return value >= min && value <= max;
}

@end
