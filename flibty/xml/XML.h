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
#import "XMLLoadWatcher.h"
#import "XMLLoader.h"
#import "StringUtil.h"


@interface XML : NSObject {
    NSString* elementName;
    NSString* namespaceURI;
    NSString* qName;

    NSString* nodeValue;

    NSMutableDictionary* attributes;
    NSMutableDictionary* elements;
}

/**
 * This static method will load a remote XML url and return an XML object once the load has completed.
 */
+(void)loadWithUrlString:(NSString*)urlString onLoadComplete:(void (^)(XML* xml))completeCallback;

+(void)loadXmlString:(NSString*)xmlString onLoadComplete:(void (^)(XML* xml))completeCallback;

/**
 * This method initializes and returns a new instance an XML instance
 */
-(id)initWith:(NSString*)eleName ns:(NSString*)nsURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDictionary;

/**
 * This method returns an XML attribute value using the name
 */
-(NSString*)attributeByName:(NSString*)name;

/**
 * This method returns either an XML object or an NSMutableArray containing a list of XML elements.
 */
-(id)elementByName:(NSString*)name;

/**
 * This method appends additional XML elements to this node.
 */
-(void)appendElement:(XML*)element;

/**
 * This method will generate the NSString representation of the XML object.
 */
-(NSString*)toString;

/**
 * This method will generate the NSString representation of the XML object using a specified tab string.
 */
-(NSString*)toString:(NSString*)tab;

@property(readonly, nonatomic) NSString* elementName;
@property(readonly, nonatomic) NSString* namespaceURI;
@property(readonly, nonatomic) NSString* qName;

/**
 * This property contains the node value of the XML
 */
@property(readwrite, nonatomic, retain) NSString* nodeValue;

@end


/**
 * @private
 * this interface contains the private methods of the XML class
 */
@interface XML (private)

/**
 * This method concatenates two NSString objects
 */
-(NSString*)concat:(NSString*)string1 withString:(NSString*)string2;

@end
