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

@class GCDAsyncSocket;
@class FlibtyServer;
@protocol FlibtyConnectionDelegate;
@protocol LogTarget;
@protocol LogParser;

extern const NSUInteger LOG_TAG;
extern const NSUInteger POLICY_TAG;
extern const NSString* const POLICY_FILE;

@interface FlibtyConnection : NSObject {
    GCDAsyncSocket* socket;
    NSString* key;
    NSData* policyData;

    id<LogTarget> logTarget;
    id<LogParser> logParser;
    __weak id<FlibtyConnectionDelegate> delegate;
}

-(id)initWith:(GCDAsyncSocket*)clientSocket andLogTarget:(id<LogTarget>)logTarget parsedWith:(id<LogParser>)parser;
-(void)disconnect;

@property(readonly, nonatomic) NSString* key;
@property(readonly, nonatomic) GCDAsyncSocket* socket;
@property(weak) id<FlibtyConnectionDelegate> delegate;
@property(readonly, nonatomic) id<LogTarget> logTarget;
@property(readonly, nonatomic) id<LogParser> logParser;

@end

@interface FlibtyConnection(private)
-(void)parseAndLog:(NSData*)data;
@end