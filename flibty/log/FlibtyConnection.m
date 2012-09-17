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

#import "FlibtyConnection.h"
#import "GCDAsyncSocket.h"
#import "FlibtyConnectionDelegate.h"
#import "FlibtyHelper.h"
#import "LogTarget.h"
#import "LogParser.h"
#import "Log.h"

const NSUInteger LOG_TAG = 1;
const NSUInteger POLICY_TAG = 10;
const NSUInteger POST_POLICY_TAG = 11;

const NSString* const POLICY_FILE = @""
"<?xml version=\"1.0\"?>\n"
"<cross-domain-policy>\n"
"    <allow-access-from domain=\"*\" to-ports=\"*\" />\n"
"</cross-domain-policy>\x00";


@implementation FlibtyConnection {
    BOOL isReady;
}

@synthesize key;
@synthesize socket;
@synthesize logTarget;
@synthesize logParser;

-(id)initWithSocket:(GCDAsyncSocket*)clientSocket parsedWith:(id<LogParser>)parser {
    return [self initWithDelegate:nil socket:clientSocket parsedWith:parser];
}

-(id)initWithDelegate:(id<FlibtyConnectionDelegate>)delegate socket:(GCDAsyncSocket*)clientSocket parsedWith:(id<LogParser>)parser {
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
        
        key = [FlibtyHelper keyFor:clientSocket];
        socket = clientSocket;
        socket.delegate = self;
        logParser = parser;
        isReady = NO;
        policyData = [POLICY_FILE dataUsingEncoding:NSUTF8StringEncoding];
        
        [socket readDataToData:[GCDAsyncSocket ZeroData] withTimeout:-1 tag:LOG_TAG];
    }
    
    return self;

}

-(void)disconnect {
    [socket disconnect];
}

-(void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag {
    if (tag == POLICY_TAG) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(policyFileSent:)]) {
            [self.delegate policyFileSent:self];
        }
        
        [sock readDataToData:[GCDAsyncSocket ZeroData] withTimeout:-1 tag:POST_POLICY_TAG];
    }
}

-(void)socket:(GCDAsyncSocket*)sock didReadData:(NSData*)data withTag:(long)tag {
    if (tag == POST_POLICY_TAG) {
        NSLog(@"WARNING: Post-Policy TAG was found!");
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
            [logParser parse:data andCallback:^(Log* log) {
                // Error - bad parsing
                if (!log) {
                    NSLog(@"ERROR: Could not parse socket data into log.");
                    return;
                }
                
                // Log was actually a policy file request, which we write back to the client
                if (log.isPolicyFileRequest) {
                    NSLog(@"Is Policy File Request... Sending Data");
                    [sock writeData:policyData withTimeout:-1 tag:POLICY_TAG];
                    return;
                }
                
                // If we have not yet notified our delegate of a successful logging connection, do so.
                if (!isReady) {
                    if (self.delegate) {
                        [self.delegate socketDidConnect:self];
                    }
                    isReady = YES;
                }
                
                // Pass the Log* to the logging target
                [logTarget log:log];
                
                // Queue a socket read for the next incoming log
                [socket readDataToData:[GCDAsyncSocket ZeroData] withTimeout:-1 tag:LOG_TAG];
            }];
        }
    });
}

-(void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err {
    if (sock == socket) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @autoreleasepool {
                NSLog(@"client disconnected, error: %@", err);
            }
        });
        
        if (self.delegate) {
            [self.delegate socketDisconnected:self];
        }
    }
}


@end