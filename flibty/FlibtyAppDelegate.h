//
//  FlibtyAppDelegate.h
//  flibty
//
//  Created by Matt Bolt on 8/19/12.
//  Copyright (c) 2012 Matt Bolt. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FlibtyServer.h"

@class LogContainer;

@interface FlibtyAppDelegate : NSObject <NSApplicationDelegate> {
    FlibtyServer* server;
    LogContainer* logContainer;
}

@property(assign) IBOutlet NSWindow* window;
@property(readonly, nonatomic) LogContainer* logContainer;
@property(readonly, nonatomic) FlibtyServer* server;

@end
