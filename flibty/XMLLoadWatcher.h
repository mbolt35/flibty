////////////////////////////////////////////////////////////////////////////////
//
//  MATTBOLT.BLOGSPOT.COM
//  Copyright(C) 2010 Matt Bolt
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "XML.h"
#import "XMLLoader.h"
#import "XMLLoaderDelegate.h"

// Type the callback block
typedef void(^CallbackBlock)(XML* xml);

@interface XMLLoadWatcher : NSObject <XMLLoaderDelegate> {
	CallbackBlock callback;
}

+ (id)watcher:(XMLLoader*)loader onLoadComplete:(void(^)(XML* xml))completeCallback;

- (void)watch:(XMLLoader*)loader onLoadComplete:(void(^)(XML* xml))completeCallback;

- (void)xmlLoadStarted:(XMLLoader*)loader;

- (void)xmlLoadCompleted:(XMLLoader*)loader withResult:(XML*)xml;

- (void)xmlLoadError:(XMLLoader*)loader withError:(NSError*)error;

@end
