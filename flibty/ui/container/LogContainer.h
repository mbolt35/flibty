//
// Created by mattbolt on 9/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Log.h"
#import "LogDataSource.h"


@interface LogContainer : NSViewController<NSOutlineViewDelegate> {
    LogDataSource* dataSource;
}

-(id)initWithFrame:(NSRect)rect;
-(void)addLog:(Log*)log;

@property(assign) IBOutlet NSOutlineView* outlineView;


@end