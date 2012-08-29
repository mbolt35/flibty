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
