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

#import "TabbedLogTargetFactory.h"
#import "TabbedLogTarget.h"
#import "TabModel.h"


@implementation TabbedLogTargetFactory

-(id)initWith:(LogContainer*)container {
    if ((self = [super init])) {
        logContainer = container;
    }
    return self;
}

-(id)initWithTabs:(NSTabView*)tabs {
    if ((self = [super init])) {
        tabView = tabs;
        tabTargets = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return self;
}

-(id<LogTarget>)newLogTarget:(NSString*)withName {
    LogContainer* container = [[LogContainer alloc] initWithFrame:tabView.frame];
    TabbedLogTarget* target = [[TabbedLogTarget alloc] initWith:container andName:withName];
    
    NSTabViewItem* item = [[NSTabViewItem alloc] initWithIdentifier:[[TabModel alloc] initWithName:withName]];
    item.view = target.view;
    item.label = withName;

    tabTargets[withName] = @{ @"container" : container, @"item" : item, @"target" : target };
    
    [tabView addTabViewItem:item];
    
    return target;
}

-(void)tabView:(NSTabView*)aTabView didCloseTabViewItem:(NSTabViewItem*)tabViewItem {
    TabModel* model = (TabModel*)tabViewItem.identifier;
    
    NSDictionary* value = tabTargets[model.name];
    LogContainer* container = value[@"container"];
    NSTabViewItem* item = value[@"item"];
    id<LogTarget> target = value[@"target"];
    
    if (target.delegate) {
        [target.delegate onTargetClosed:target];
    }
    
    [tabView removeTabViewItem:item];
    [container close];
    
    [tabTargets removeObjectForKey:model.name];
}


@end