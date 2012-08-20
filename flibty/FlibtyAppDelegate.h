//
//  FlibtyAppDelegate.h
//  flibty
//
//  Created by Matt Bolt on 8/19/12.
//  Copyright (c) 2012 Matt Bolt. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FlibtyServer.h"

@interface FlibtyAppDelegate : NSObject <NSApplicationDelegate> {
    FlibtyServer* server;
}

@property(assign) IBOutlet NSWindow* window;
@property(assign) IBOutlet NSTextView* textView;
@property(readonly, nonatomic) FlibtyServer* server;

@end
