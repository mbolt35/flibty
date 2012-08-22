//
//  FlibtyAppDelegate.m
//  flibty
//
//  Created by Matt Bolt on 8/19/12.
//  Copyright (c) 2012 Matt Bolt. All rights reserved.
//

#import "FlibtyAppDelegate.h"

@implementation FlibtyAppDelegate

@synthesize textView;
@synthesize window;
@synthesize server;

-(void)applicationDidFinishLaunching:(NSNotification*)aNotification {
    window.title = @"Flibty";

    server = [[FlibtyServer alloc] init];
    [server start:@"localhost" port:4444];
}

-(void)applicationWillTerminate:(NSNotification*)notification {
    if (nil != server && server.isRunning) {
        [server stop];
    }
}

@end
