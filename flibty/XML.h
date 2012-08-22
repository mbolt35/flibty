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
