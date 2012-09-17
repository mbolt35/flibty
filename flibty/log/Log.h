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

/**
 * This class represents a Log instance, which exists as a policy-file-request, a 
 * single-line log, or a multi-line log.
 */
@interface Log : NSObject {
    NSString* _level;
    NSString* _title;
    NSString* _message;
    
    NSString* _label;

    BOOL _isMultiLine;
    BOOL _isPolicyFileRequest;
}

/**
 * This method initializes the Log instance as a policy-file-request.
 */
-(id)initAsPolicyFileRequest;

/**
 * This method initializes the Log instance as a single-lined log message.
 */
-(id)initWith:(NSString*)logLevel andMessage:(NSString*)logMessage;

/**
 * This method initializes the Log instance as a multi-line log message where the 
 * visible line is the title, and the rest of the log message is in the message.
 */
-(id)initWith:(NSString*)logLevel andTitle:(NSString*)logTitle andMessage:(NSString*)logMessage;

/**
 * This property contains the logging level used for the Log. ie: INFO, DEBUG, etc...
 */
@property(readonly, nonatomic) NSString* level;

/**
 * This property is set to the full log on a single line Log, and "folded" message on
 * a multi-line Log.
 */
@property(readonly, nonatomic) NSString* message;

/**
 * This property is set to the title of a multi-line log. That is, the non-folded single-line
 * description of the full log.
 */
@property(readonly, nonatomic) NSString* title;

/**
 * This returns a NSString representing the full Log.
 */
@property(readonly, nonatomic) NSString* label;

/**
 * Whether or not this Log instance is multi-line or not.
 */
@property(readonly, nonatomic) BOOL isMultiLine;

/**
 * Whether or not this Log instance is a policy-file-request or not.
 */
@property(readonly, nonatomic) BOOL isPolicyFileRequest;

@end