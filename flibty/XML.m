////////////////////////////////////////////////////////////////////////////////
//
//  MATTBOLT.BLOGSPOT.COM
//  Copyright(C) 2010 Matt Bolt
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "XML.h"


@implementation XML

@synthesize elementName;
@synthesize namespaceURI;
@synthesize qName;
@synthesize nodeValue;

/**
 * This static method loads an xml file using a remote url, and returns the XML
 * object via the callback selector.
 */
+(void)loadWithUrlString:(NSString*)urlString onLoadComplete:(void (^)(XML* xml))completeCallback {
    XMLLoader* loader = [[XMLLoader alloc] initWithURLString:urlString];
    [XMLLoadWatcher watcher:loader onLoadComplete:completeCallback];

    [loader load];
}

/**
 * This static method loads an xml file using a string containing xml text.
 */
+(void)loadXmlString:(NSString*)xmlString onLoadComplete:(void (^)(XML* xml))completeCallback {
    XMLLoader* loader = [[XMLLoader alloc] initWithXmlString:xmlString];
    [XMLLoadWatcher watcher:loader onLoadComplete:completeCallback];

    [loader load];
}

/**
 * This method initializes and returns a new instance an XML instance
 */
-(id)initWith:(NSString*)eleName ns:(NSString*)nsURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDictionary {
    if (self = [super init]) {
        elementName = eleName;
        namespaceURI = nsURI;
        qName = qualifiedName;

        attributes = [NSMutableDictionary dictionaryWithDictionary:attributeDictionary];
        elements = [NSMutableDictionary dictionary];
    }

    return self;
}

/**
 * This method returns an XML attribute value using the name
 */
-(NSString*)attributeByName:(NSString*)name {
    return [attributes objectForKey:name];
}

/**
 * This method returns either an XML object or an NSMutableArray containing a list of XML elements.
 */
-(id)elementByName:(NSString*)name {
    return [elements objectForKey:name];
}

/**
 * This method appends additional XML elements to this node.
 */
-(void)appendElement:(XML*)element {
    id obj = [elements objectForKey:element.elementName];

    if (obj != nil) {
        NSMutableArray* arr;

        if ([obj isKindOfClass:[NSMutableArray class]]) {
            arr = (NSMutableArray*) obj;
            [arr addObject:element];
        } else if ([obj isKindOfClass:[XML class]]) {
            arr = [NSMutableArray arrayWithObjects:obj, element, nil];
            [elements setObject:arr forKey:element.elementName];
        }
    } else {
        [elements setObject:element forKey:element.elementName];
    }
}

/**
 * This method will generate the NSString representation of the XML object.
 */
-(NSString*)toString {
    return [self toString:@""];
}

/**
 * This method will generate the NSString representation of the XML object using a specified tab string.
 */
-(NSString*)toString:(NSString*)tab {
    NSString* str = [NSString stringWithFormat:@"%@<%@", tab, elementName];
    NSString* newTab = [StringUtil concat:tab withString:@"  "];

    // Add in the Attributes
    if ([attributes count] > 0) {
        for (id attribKey in attributes) {
            str = [StringUtil concat:str withString:[NSString stringWithFormat:@" %@=\"%@\"", attribKey, [attributes objectForKey:attribKey]]];
        }
    }

    // Add any additional elements
    if ([elements count] > 0) {
        str = [StringUtil concat:str withString:@">\n"];

        for (id key in elements) {
            id obj = [elements objectForKey:key];

            if ([obj isKindOfClass:[NSMutableArray class]]) {
                for (XML* ele in obj) {
                    str = [StringUtil concat:str withString:[ele toString:newTab]];
                }
            } else {
                str = [StringUtil concat:str withString:[(XML*) [elements objectForKey:key] toString:newTab]];
            }
        }
    } else {
        if (nodeValue == nil) {
            return [StringUtil concat:str withString:[NSString stringWithFormat:@"/>\n"]];
        }

        return [StringUtil concat:str withString:[NSString stringWithFormat:@">%@</%@>\n", nodeValue, elementName]];
    }

    return [NSString stringWithFormat:@"%@%@</%@>\n", str, tab, elementName];
}

/**
 * @private 
 * string concatenation
 */
-(NSString*)concat:(NSString*)string1 withString:(NSString*)string2 {
    return [NSString stringWithFormat:@"%@%@", string1, string2];
}


@end
