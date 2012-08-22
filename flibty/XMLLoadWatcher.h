#import <Foundation/Foundation.h>
#import "XML.h"
#import "XMLLoader.h"
#import "XMLLoaderDelegate.h"

typedef void(^XMLLoadCallback)(XML* xml);

@interface XMLLoadWatcher : NSObject <XMLLoaderDelegate> {
    XMLLoadCallback callback;
}

+(id)watcher:(XMLLoader*)loader onLoadComplete:(XMLLoadCallback)completeCallback;

-(void)watch:(XMLLoader*)loader onLoadComplete:(XMLLoadCallback)completeCallback;

-(void)xmlLoadStarted:(XMLLoader*)loader;

-(void)xmlLoadCompleted:(XMLLoader*)loader withResult:(XML*)xml;

-(void)xmlLoadError:(XMLLoader*)loader withError:(NSError*)error;

@end
