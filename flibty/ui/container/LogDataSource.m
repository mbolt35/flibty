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

#import <Cocoa/Cocoa.h>
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
        return logEntries[index];
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
