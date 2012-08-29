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

    if ([msg rangeOfString:@"policy-file-request"].location != NSNotFound) {
        NSLog(@"Policy file requested, serving.");
        callback([[Log alloc] initAsPolicyFileRequest]);
        return;
    }

    NSRange range = [msg rangeOfString:@"!SOS"];

    if (range.location != NSNotFound) {
        NSString* xmlString = [msg substringFromIndex:range.location + range.length];

        [XML loadXmlString:xmlString onLoadComplete:^(XML* xml) {
            @autoreleasepool {
                NSString* level = [xml attributeByName:@"key"];
                NSString* elementName = xml.elementName;
                BOOL isMultiLine = [elementName rangeOfString:@"showFoldMessage"].location != NSNotFound;

                NSString* message;
                if (isMultiLine) {
                    id title = [xml elementByName:@"title"];
                    id nodeMessage = [xml elementByName:@"message"];

                    if (![title isKindOfClass:[XML class]] || ![nodeMessage isKindOfClass:[XML class]]) {
                        callback(nil);
                        return;
                    }

                    message = [NSString stringWithFormat:@"%@\n%@", ((XML*)title).nodeValue, ((XML*)nodeMessage).nodeValue];
                } else {
                    message = xml.nodeValue;
                }


                callback([[Log alloc] initWith:level andMessage:message isMultipleLines:isMultiLine]);
            }
        }];
    }
}

@end