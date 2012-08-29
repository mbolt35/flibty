//
//  FlibtyAppDelegate.m
//  flibty
//
//  Created by Matt Bolt on 8/19/12.
//  Copyright (c) 2012 Matt Bolt. All rights reserved.
//

#import "FlibtyAppDelegate.h"
#import "TabbedLogTargetFactory.h"

@implementation FlibtyAppDelegate

@synthesize window;
@synthesize server;

-(void)applicationDidFinishLaunching:(NSNotification*)aNotification {
    window.title = @"Flibty";

    /*
    NGColoredViewController *vc1 = [[NGColoredViewController alloc] initWithNibName:nil bundle:nil];
    NGColoredViewController *vc2 = [[NGColoredViewController alloc] initWithNibName:nil bundle:nil];
    NGColoredViewController *vc3 = [[NGColoredViewController alloc] initWithNibName:nil bundle:nil];
    NGColoredViewController *vc4 = [[NGColoredViewController alloc] initWithNibName:nil bundle:nil];
    NGColoredViewController *vc5 = [[NGColoredViewController alloc] initWithNibName:nil bundle:nil];

    vc1.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"Home" image:image1];
    vc2.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"Images" image:image2];
    vc3.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"Live" image:image3];
    vc4.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"Contact" image:image4];
    vc5.ng_tabBarItem = [NGTabBarItem itemWithTitle:@"Settings" image:image5];

    NSArray *viewController = [NSArray arrayWithObjects:vc1,vc2,vc3,vc4,vc5,nil];

    NGTabBarController *tabBarController = [[NGTestTabBarController alloc] initWithDelegate:self];

    tabBarController.animation = NGTabBarControllerAnimationMoveAndScale;
    tabBarController.layoutStrategy = $isPhone() ? NGTabBarLayoutStrategyEvenlyDistributed : NGTabBarLayoutStrategyCentered;
    tabBarController.itemPadding = 10.f;
    tabBarController.showsItemHighlight = NO;
    tabBarController.tintColor = [UIColor redColor];
    tabBarController.viewControllers = viewController;
    self.window.rootViewController = tabBarController;
    */

    server = [[FlibtyServer alloc] initWith:[[TabbedLogTargetFactory alloc] init]];
    [server start:@"localhost" port:4444];
}

-(void)applicationWillTerminate:(NSNotification*)notification {
    if (nil != server && server.isRunning) {
        [server stop];
    }
}

@end
