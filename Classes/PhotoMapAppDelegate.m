//
//  PhotoMapAppDelegate.m
//  PhotoMap
//
//  Created by Jernej Fijačko on 26.9.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "PhotoMapAppDelegate.h"
#import "PhotoHandler.h"
#import "EXF.h"

BOOL gLogging = FALSE;

@implementation PhotoMapAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
	controller = [[MyMapController alloc] init];
	navigation = [[UINavigationController alloc] initWithRootViewController:controller];
	[window addSubview:navigation.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[navigation release];
	[controller release];
    [window release];
    [super dealloc];
}


@end
