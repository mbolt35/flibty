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

#import "TabbedLogTarget.h"
#import "Log.h"


@implementation TabbedLogTarget


-(id)initWith:(LogContainer*)container andName:(NSString*)targetName {
    self = [super initWithNibName:@"TabbedLogView" bundle:[NSBundle mainBundle]];
    if (self) {
        logContainer = container;
        name = targetName;
        
        self.view.autoresizesSubviews = YES;
        [self.view addSubview:logContainer.view];
        
        logContainer.view.frame = self.view.frame;
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(onViewResize:)
         name:NSViewFrameDidChangeNotification
         object:self.view];
    }
    return self;
}

-(void)log:(Log*)log {
    [logContainer addLog:log];
}

-(NSString*)name {
    return name;
}

-(void)close {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:NSViewFrameDidChangeNotification
     object:self.view];
    
    [logContainer close];
}

-(void)onViewResize:(NSNotification*)notification {
    NSRect r = self.view.frame;
    NSRect newRect = NSMakeRect(0, 0, r.size.width, r.size.height);
    
    logContainer.view.frame = newRect;
}

@end