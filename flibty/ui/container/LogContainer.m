//
// Created by mattbolt on 9/2/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LogContainer.h"

@implementation LogContainer {
    BOOL isManualScroll;
    BOOL hasReachedCapacity;
}

@synthesize outlineView;

-(id)initWithFrame:(NSRect)rect {
    self = [super initWithNibName:@"LogContainer" bundle:[NSBundle mainBundle]];

    if (self) {
        self.view.frame = rect;
        dataSource = [[LogDataSource alloc] init];
        outlineView.dataSource = dataSource;
        
        ((NSScrollView*)self.view).postsBoundsChangedNotifications = YES;
        [[NSNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(onBoundsChanged:)
            name:NSViewBoundsDidChangeNotification
            object:((NSScrollView*)self.view).contentView];
        
        isManualScroll = NO;
        hasReachedCapacity = NO;
    }

    return self;
}

-(void)addLog:(Log*)log {
    // Adds the Log instance to the data source and updates the outline view
    // TODO: Can the "reload" be done more efficiently, or is it already optimized?
    [dataSource add:log];
    [outlineView reloadData];
    
    // if we have started scrolling manually, do not force the scroller to the end
    if (!isManualScroll) {
        [outlineView scrollRowToVisible:outlineView.numberOfRows - 1];
    }
}

-(void)onBoundsChanged:(NSNotification*)notification {
    // if our scroller reaches 95% of the view size, "lock it"
    float scrollPos = ((NSScrollView*)self.view).verticalScroller.floatValue;
    if (!hasReachedCapacity && scrollPos > 0.95) {
        hasReachedCapacity = YES;
    }
    
    NSTableColumn* column = [self.outlineView.tableColumns objectAtIndex:0];
    column.width = self.outlineView.frame.size.width;
    
    isManualScroll = hasReachedCapacity && scrollPos < 0.95;
}

-(void)outlineViewItemDidExpand:(NSNotification *)notification {

}

-(void)outlineViewItemDidCollapse:(NSNotification *)notification {
    
}

-(CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item {
    // since we're only using a single column, use the 0-index
    NSCell* textCell = [self.outlineView preparedCellAtColumn:0 row:[self.outlineView rowForItem:item]];
    CGFloat heightValue = [textCell cellSizeForBounds:CGRectMake(0, 0, self.outlineView.frame.size.width, CGFLOAT_MAX)].height;

    return heightValue;
}


@end