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

#import "TabModel.h"

@implementation TabModel

@synthesize name;
@synthesize icon;
@synthesize largeImage;
@synthesize iconName;
@synthesize isProcessing;
@synthesize isEdited;
@synthesize objectCount;

-(id)init {
    self = [super init];
    if (self) {
        isProcessing = NO;
		icon = nil;
		iconName = nil;
        largeImage = nil;
		objectCount = 0;
		isEdited = NO;
    }
    
    return self;
}

-(id)initWithName:(NSString*)modelName {
    self = [self init];
    if (self) {
        name = modelName;
    }
    return self;
}

@end
