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

#import "SOSLogParser.h"
#import "Log.h"
#import "XML.h"


@implementation SOSLogParser

-(void)parse:(NSData*)data andCallback:(LogParseCallback)callback {
    NSData* strData = [data subdataWithRange:NSMakeRange(0, data.length - 1)];
    NSString* msg = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];

    if (!msg) {
        callback(nil);
        return;
    }

    if ([msg rangeOfString:POLICY_REQUEST].location != NSNotFound) {
        NSLog(@"Policy file requested, serving.");
        callback([[Log alloc] initAsPolicyFileRequest]);
        return;
    }

    NSRange range = [msg rangeOfString:SOS];

    if (range.location != NSNotFound) {
        NSString* xmlString = [msg substringFromIndex:range.location + range.length];

        [XML loadXmlString:xmlString onLoadComplete:^(XML* xml) {
            @autoreleasepool {
                NSString* level = [xml attributeByName:KEY];
                NSString* elementName = xml.elementName;
                BOOL isMultiLine = [elementName rangeOfString:FOLDED].location != NSNotFound;

                NSString* title;
                NSString* message;
                
                if (isMultiLine) {
                    id nodeTitle = [xml elementByName:TITLE];
                    id nodeMessage = [xml elementByName:MESSAGE];

                    if (![nodeTitle isKindOfClass:[XML class]] || ![nodeMessage isKindOfClass:[XML class]]) {
                        callback(nil);
                        return;
                    }

                    title = ((XML*)nodeTitle).nodeValue;
                    message = ((XML*)nodeMessage).nodeValue;
                    
                    callback([[Log alloc] initWith:level andTitle:title andMessage:message]);
                    return;
                }
                
                message = xml.nodeValue;
                callback([[Log alloc] initWith:level andMessage:message]);
            }
        }];
    }
}

@end