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

#import "LogTargetDelegate.h"

@protocol LogTargetDelegate;
@class Log;


/**
 * The LogTarget protocol represents an object that is capable of processing a Log
 * instance.
 */
@protocol LogTarget <NSObject>

/**
 * This method sends a Log instance to the LogTarget for processing.
 */
-(void)log:(Log*)log;

/**
 * The LogTarget instance should always have an NSString identifier.
 */
@property(readonly, nonatomic) NSString* name;


@optional

/**
 * A LogTarget can optionally delegate specific behavior to a LogTargetDelegate implementer.
 */
@property(weak) id<LogTargetDelegate> delegate;

@end