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
#import "XML.h"
#import "XMLLoaderDelegate.h"

@class XML;

@interface XMLLoader : NSObject <NSXMLParserDelegate> {
    NSXMLParser* xmlParser;
    NSMutableArray* elementStack;

    __weak id <XMLLoaderDelegate> delegate;

    XML* currentElement;

    BOOL isLoading;
    BOOL isLoaded;
}

/**
 *
 */
-(id)initWithURLString:(NSString*)url;

/**
 *
 */
-(id)initWithXmlString:(NSString*)xmlString;

/**
 *
 */
-(void)load;

@property(nonatomic, weak) id <XMLLoaderDelegate> delegate;
@property(readonly, nonatomic) BOOL isLoading;
@property(readonly, nonatomic) BOOL isLoaded;
@property(readonly, nonatomic, getter=xml) XML* currentElement;

@end

@interface XMLLoader (private)
-(BOOL)isAllWhiteSpace:(NSString*)string;

-(void)notifyDelegateOfError:(NSError*)error;
@end
