#import <Foundation/Foundation.h>
#import "XML.h"
#import "XMLLoader.h"

@class XMLLoader, XML;

/**
 * This protocol defines an implementation of an xml load delegate. It is notified
 * when the XML object reaches certain stages in the load.
 */
@protocol XMLLoaderDelegate <NSObject>

@required
- (void)xmlLoadCompleted:(XMLLoader*)loader withResult:(XML*)xml;

@optional
- (void)xmlLoadStarted:(XMLLoader*)loader;
- (void)xmlLoadError:(XMLLoader*)loader withError:(NSError*)error;

@end
