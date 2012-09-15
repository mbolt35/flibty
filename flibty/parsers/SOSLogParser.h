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
#import "LogParser.h"

// Use defines instead of constants, as rangeOfString doesn't accept const NSString*
// Cloning the constant would be similar to using #define, except more difficult to read.
#define SOS @"!SOS"
#define POLICY_REQUEST @"policy-file-request"
#define KEY @"key"
#define FOLDED @"showFoldMessage"
#define TITLE @"title"
#define MESSAGE @"message"


@interface SOSLogParser : NSObject<LogParser> {

}

@end