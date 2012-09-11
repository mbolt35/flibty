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

-(void)applicationDidFinishLaunching:(NSNotification*)aNotification {
    NSRect windowRect = ((NSView*)window.contentView).frame; // NSRectFromCGRect(CGRectMake(0, 0, window.frame.size.width, window.frame.size.height));
    logContainer = [[LogContainer alloc] initWithFrame:windowRect];
    server = [[FlibtyServer alloc] initWith:[[TabbedLogTargetFactory alloc] initWith:logContainer]];

    [window.contentView addSubview:logContainer.view];
    NSView* winView = window.contentView;
    winView.autoresizesSubviews = YES;
    
    [server start:@"localhost" port:4444];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onViewResize:)
     name:NSViewFrameDidChangeNotification
     object:winView];
}

-(void)applicationWillTerminate:(NSNotification*)notification {
    if (nil != server && server.isRunning) {
        [server stop];
    }
}

-(void)onViewResize:(NSNotification*)notification {
    logContainer.view.frame = ((NSView*)window.contentView).frame;
}

@end
