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

const NSString* const POLICY_FILE = @""
        "<?xml version=\"1.0\"?>\n"
        "<!DOCTYPE cross-domain-policy SYSTEM \"http://www.macromedia.com/xml/dtds/cross-domain-policy.dtd\">\n"
        "<cross-domain-policy>\n"
        "    <allow-access-from domain=\"*\" to-ports=\"*\" />\n"
        "</cross-domain-policy>\x00";


@implementation FlibtyConnection

@synthesize key;
@synthesize socket;
@synthesize delegate;
@synthesize logTarget;
@synthesize logParser;

-(id)initWith:(GCDAsyncSocket*)clientSocket andLogTarget:(id<LogTarget>)target parsedWith:(id<LogParser>)parser {
    if ((self = [super init])) {
        key = [FlibtyHelper keyFor:clientSocket];
        socket = clientSocket;
        socket.delegate = self;
        logTarget = target;
        logParser = parser;
        policyData = [POLICY_FILE dataUsingEncoding:NSUTF8StringEncoding];

        [socket readDataToData:[GCDAsyncSocket ZeroData] withTimeout:-1 tag:0];
    }

    return self;
}

-(void)disconnect {
    [socket disconnect];
}

-(void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag {
    if (tag == POLICY_TAG) {
        if (delegate && [delegate respondsToSelector:@selector(policyFileSent:)]) {
            [delegate policyFileSent:self];
        }

        [sock readDataToData:[GCDAsyncSocket ZeroData] withTimeout:-1 tag:LOG_TAG];
    }
}

-(void)socket:(GCDAsyncSocket*)sock didReadData:(NSData*)data withTag:(long)tag {
    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
            [logParser parse:data andCallback:^(Log* log) {
                @autoreleasepool {
                    if (log) {
                        if (log.isPolicyFileRequest) {
                            NSLog(@"Is Policy File Request... Sending Data");
                            [sock writeData:policyData withTimeout:-1 tag:POLICY_TAG];
                        } else {
                            [logTarget log:log.level message:log.message];
                            [socket readDataToData:[GCDAsyncSocket ZeroData] withTimeout:-1 tag:LOG_TAG];
                        }
                    } else {
                        NSLog(@"Error parsing socket data into log.");
                    }
                }

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

        if (delegate && [delegate respondsToSelector:@selector(socketDisconnected:)]) {
            [delegate socketDisconnected:self];
        }
    }
}


@end