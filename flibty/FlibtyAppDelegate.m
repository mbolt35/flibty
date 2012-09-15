//
//  FlibtyAppDelegate.m
//  flibty
//
//  Created by Matt Bolt on 8/19/12.
//  Copyright (c) 2012 Matt Bolt. All rights reserved.
//

#import "FlibtyAppDelegate.h"
#import "TabbedLogTargetFactory.h"
#import "LogContainer.h"
#import "Log.h"

@implementation FlibtyAppDelegate

@synthesize window;
@synthesize server;
@synthesize tabView;

-(void)applicationDidFinishLaunching:(NSNotification*)aNotification {
    server = [[FlibtyServer alloc] initWith:[[TabbedLogTargetFactory alloc] initWithTabs:tabView]];
    
    NSView* winView = window.contentView;
    winView.autoresizesSubviews = YES;
    
    [server start:@"localhost" port:4444];
}

-(void)applicationWillTerminate:(NSNotification*)notification {
    if (nil != server && server.isRunning) {
        [server stop];
    }
}

@end
