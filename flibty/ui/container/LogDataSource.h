//
//  LogDataSource.h
//  flibty
//
//  Created by Matt Bolt on 9/9/12.
//  Copyright (c) 2012 Matt Bolt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Log.h"

@interface LogDataSource : NSObject<NSOutlineViewDataSource> {
    NSMutableArray* logEntries;
}

-(void)add:(Log*)log;
-(NSUInteger)indexOfObject:(Log*)log;

@end
