////////////////////////////////////////////////////////////////////////////////
//
//  MATTBOLT.BLOGSPOT.COM
//  Copyright(C) 2010 Matt Bolt
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#import "XMLLoadWatcher.h"


@implementation XMLLoadWatcher


+ (id)watcher:(XMLLoader*)loader onLoadComplete:(void(^)(XML* xml))completeCallback {
    XMLLoadWatcher* w = [[XMLLoadWatcher alloc] init];
    [w watch:loader onLoadComplete:completeCallback];
    
    return w;
}

- (void)watch:(XMLLoader*)loader onLoadComplete:(void(^)(XML* xml))completeCallback {
    loader.delegate = self;
    
    callback = completeCallback;
}

- (void)xmlLoadStarted:(XMLLoader*)loader {
    //NSLog(@"XML Load Started...");
}

- (void)xmlLoadCompleted:(XMLLoader*)loader withResult:(XML*)xml {
    callback(xml);
}

- (void)xmlLoadError:(XMLLoader*)loader withError:(NSError*)error {
    callback(nil);
}

@end
