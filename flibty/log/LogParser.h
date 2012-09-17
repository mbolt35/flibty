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

@class Log;

/**
 * Define a block type to be used when parsing a Log instance.
 */
typedef void(^LogParseCallback)(Log* log);


/**
 * This protocol defines an object which can parse a Log instance from NSData. It's
 * currently very specific to the Flibty implementation, but could easily be updated
 * to accept a variety of input. 
 */
@protocol LogParser <NSObject>

/**
 * This method parses the NSData instance passed, and executes the callback, passing back
 * the Log instance as the callback parameter. nil is passed back should the parsing fail.
 */
-(void)parse:(NSData*)data andCallback:(LogParseCallback)callback;

@end