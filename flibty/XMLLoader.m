#import "XMLLoader.h"


@implementation XMLLoader

@synthesize isLoading, isLoaded;
@synthesize delegate;
@synthesize currentElement;

-(id)initWithURLString:(NSString*)url {
    if (self = [super init]) {
        elementStack = [[NSMutableArray alloc] init];

        xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
        [xmlParser setDelegate:self];
    }

    return self;
}

-(id)initWithXmlString:(NSString*)xmlString {
    if (self = [super init]) {
        elementStack = [[NSMutableArray alloc] initWithCapacity:1];

        NSData* data = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
        xmlParser = [[NSXMLParser alloc] initWithData:data];
        [xmlParser setDelegate:self];
    }

    return self;
}

-(void)load {
    if (!isLoading && !isLoaded) {

        if (delegate && [delegate respondsToSelector:@selector(xmlLoadStarted:)]) {
            [delegate xmlLoadStarted:self];
        }

        isLoading = [xmlParser parse];
    }
}

/**
 * Method is called when the XML starts parsing.
 */
-(void)parserDidStartDocument:(NSXMLParser*)parser {
    // NSLog(@"started parsing...");
}

/**
 * Sent when the parser has completed parsing. If this is encountered, the parse was successful.
 */
-(void)parserDidEndDocument:(NSXMLParser*)parser {
    if (delegate) {
        [delegate xmlLoadCompleted:self withResult:currentElement];
    }
}

/**
 * Sent when the parser finds an element start tag.
 */
-(void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName attributes:(NSDictionary*)attributeDict {
    XML* ele = [[XML alloc] initWith:elementName ns:namespaceURI qualifiedName:qName attributes:attributeDict];
    [elementStack addObject:ele];

    if (currentElement == nil) {
        currentElement = ele;
    } else {
        [currentElement appendElement:ele];

        currentElement = ele;
    }
}

/** 
 * Sent when an end tag is encountered. The various parameters are supplied as above.
 */
-(void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName {
    if ([elementStack count] > 1) {
        [elementStack removeLastObject];

        currentElement = (XML*) [elementStack objectAtIndex:[elementStack count] - 1];
    } else if ([elementStack count] > 0) {
        [elementStack removeLastObject];
    }
}

-(XML*)xml {
    return currentElement;
}

/**
 * This returns the string of the characters encountered thus far. You may not necessarily get the longest character 
 * run. The parser reserves the right to hand these to the delegate as potentially many calls in a row to -parser:foundCharacters:
 */
-(void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string {
    if ([self isAllWhiteSpace:string]) {
        return;
    }

    currentElement.nodeValue = string;
}

/**
 * @private
 * checks whether a string contains all white space or not
 */
-(BOOL)isAllWhiteSpace:(NSString*)string {
    for (NSUInteger x = 0; x < [string length]; ++x) {
        unichar ch = [string characterAtIndex:x];

        if (ch != ' ' && ch != '\n' && ch != '\r' && ch != '\t') {
            return NO;
        }
    }

    return YES;
}

/**
 * A comment (Text in a <!-- --> block) is reported to the delegate as a single string
 */
-(void)parser:(NSXMLParser*)parser foundComment:(NSString*)comment {

}

/**
 * This reports a CDATA block to the delegate as an NSData.
 */
-(void)parser:(NSXMLParser*)parser foundCDATA:(NSData*)CDATABlock {

}

/**
 * This gives the delegate an opportunity to resolve an external entity itself and reply with the resulting data.
 *
- (NSData *)parser:(NSXMLParser*)parser resolveExternalEntityName:(NSString*)name systemID:(NSString*)systemID {
    
}*/

/**
 * This reports a fatal error to the delegate. The parser will stop parsing.
 */
-(void)parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)parseError {
    NSLog(@"Parsing Error Occurred: %@", [parseError description]);
    [self notifyDelegateOfError:parseError];
}

/**
 * If validation is on, this will report a fatal validation error to the delegate. The parser will stop parsing.
 */
-(void)parser:(NSXMLParser*)parser validationErrorOccurred:(NSError*)validationError {
    NSLog(@"Parsing Validation Error Occurred: %@", [validationError description]);
    [self notifyDelegateOfError:validationError];
}

/**
 * @private
 * notifies the delegate (if it responds to the selector) of an error
 */
-(void)notifyDelegateOfError:(NSError*)error {
    if (delegate && [delegate respondsToSelector:@selector(xmlLoadError:withError:)]) {
        [delegate xmlLoadError:self withError:error];
    }
}


/*
 - (void)parser:(NSXMLParser*)parser foundNotationDeclarationWithName:(NSString*)name publicID:(NSString*)publicID systemID:(NSString*)systemID;
 
 - (void)parser:(NSXMLParser*)parser foundUnparsedEntityDeclarationWithName:(NSString*)name publicID:(NSString*)publicID systemID:(NSString*)systemID notationName:(NSString*)notationName;
 
 - (void)parser:(NSXMLParser*)parser foundAttributeDeclarationWithName:(NSString*)attributeName forElement:(NSString*)elementName type:(NSString*)type defaultValue:(NSString*)defaultValue;
 
 - (void)parser:(NSXMLParser*)parser foundElementDeclarationWithName:(NSString*)elementName model:(NSString*)model;
 
 - (void)parser:(NSXMLParser*)parser foundInternalEntityDeclarationWithName:(NSString*)name value:(NSString*)value;
 
 - (void)parser:(NSXMLParser*)parser foundExternalEntityDeclarationWithName:(NSString*)name publicID:(NSString*)publicID systemID:(NSString*)systemID;
 */


@end
