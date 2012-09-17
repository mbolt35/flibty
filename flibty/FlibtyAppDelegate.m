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

#import "FlibtyAppDelegate.h"
#import "TabbedLogTargetFactory.h"

@implementation FlibtyAppDelegate

-(void)applicationDidFinishLaunching:(NSNotification*)aNotification {
    TabbedLogTargetFactory* factory = [[TabbedLogTargetFactory alloc] initWithTabs:tabView];
    
    [tabBarControl setStyleNamed:@"Aqua"];
    tabBarControl.delegate = factory;
    
    server = [[FlibtyServer alloc] initWith:factory];
    [server start:@"localhost" port:4444];
}

-(void)applicationWillTerminate:(NSNotification*)notification {
    if (nil != server && server.isRunning) {
        [server stop];
    }
}

@end
