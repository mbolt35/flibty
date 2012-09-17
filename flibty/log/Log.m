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

#import "Log.h"

@implementation Log

// Synthesize all read-only properties to use backing variables.
@synthesize level = _level;
@synthesize message = _message;
@synthesize title = _title;
@synthesize label = _label;
@synthesize isMultiLine = _isMultiLine;
@synthesize isPolicyFileRequest = _isPolicyFileRequest;


-(id)initAsPolicyFileRequest {
    self = [self initWith:@"" andMessage:@""];

    if (self) {
        _isPolicyFileRequest = YES;
    }

    return self;
}

-(id)initWith:(NSString*)logLevel andMessage:(NSString*)logMessage {
    self = [self initWith:logLevel andTitle:nil andMessage:logMessage];

    if (self) {
        _isMultiLine = NO;
    }

    return self;
}

-(id)initWith:(NSString *)logLevel andTitle:(NSString *)logTitle andMessage:(NSString *)logMessage {
    self = [super init];

    if (self) {
        _level = logLevel;
        _title = logTitle;
        _message = logMessage;
        
        _isMultiLine = _title != nil;
        _isPolicyFileRequest = NO;
        
        if (_isMultiLine) {
            _label = [NSString stringWithFormat:@"[%@]: %@", _level, _title];
        } else {
            _label = [NSString stringWithFormat:@"[%@]: %@", _level, _message];
        }
    }
    
    return self;
}

@end