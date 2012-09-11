//
//  LogDataSource.m
//  flibty
//
//  Created by Matt Bolt on 9/9/12.
//  Copyright (c) 2012 Matt Bolt. All rights reserved.
//

#import "LogDataSource.h"

@implementation LogDataSource


-(id)init {
    if ((self = [super init])) {
        logEntries = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

-(void)add:(Log*)log {
    [logEntries addObject:log];
}

-(NSUInteger)indexOfObject:(Log*)log {
    return [logEntries indexOfObject:log];
}

-(NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    // if the item is nil, it's our root node, so return the total # of logs
    if (nil == item) {
        return logEntries.count;
    }
    
    // return a child length of 1 if it's a multiline log
    if ([item isKindOfClass:[Log class]] && ((Log*)item).isMultiLine) {
        return 1;
    }
    
    return 0;
}

-(id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    // this is the root, so we return the log at the index
    if (nil == item) {
        return [logEntries objectAtIndex:index];
    }
    
    // a log only has a child if it is multiline -- so just return the message.
    return ((Log*)item).message;
}

-(BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    // this is the root, so it's expandable
    if (nil == item) {
        return YES;
    }
    
    // otherwise, we expand if multiline
    return [item isKindOfClass:[Log class]] && ((Log*)item).isMultiLine;
}

-(id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    // we never display the root node, so this is acceptable
    if (nil == item) {
        return @"";
    }

    // if our item is a Log, return the label for that instance
    if ([item isKindOfClass:[Log class]]) {
        return ((Log*)item).label;
    }
    
    // otherwise, just return the item (most likely a NSString*)
    return item;
}

@end
