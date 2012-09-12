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

#import "StringUtil.h"


@implementation StringUtil

/**
 * This method concatenates two strings and returns the result.
 */
+(NSString*)concat:(NSString*)firstString withString:(NSString*)secondString {
    return [NSString stringWithFormat:@"%@%@", firstString, secondString];
}


/**
 * This method concatenates multiple strings and returns the result.
 */
+(NSString*)concatenate:(NSString*)firstString withString:(NSString*)secondString, ... {
    NSString* newString = [StringUtil concat:firstString withString:secondString];
    NSString* currentString;

    va_list stringList;

    va_start(stringList, secondString);
    while ((currentString = va_arg(stringList, NSString*))) {
        newString = [StringUtil concat:newString withString:currentString];
    }
    va_end(stringList);

    return newString;
}

@end
