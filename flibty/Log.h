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

@interface Log : NSObject {
    NSString* level;
    NSString* title;
    NSString* message;
    
    NSString* label;

    BOOL isMultiLine;
    BOOL isPolicyFileRequest;
}

-(id)initAsPolicyFileRequest;
-(id)initWith:(NSString*)logLevel andMessage:(NSString*)logMessage;
-(id)initWith:(NSString*)logLevel andTitle:(NSString*)logTitle andMessage:(NSString*)logMessage;

@property(readonly, nonatomic) NSString* level;
@property(readonly, nonatomic) NSString* message;
@property(readonly, nonatomic) NSString* title;
@property(readonly, nonatomic) NSString* label;
@property(readonly, nonatomic) BOOL isMultiLine;
@property(readonly, nonatomic) BOOL isPolicyFileRequest;

@end