//
//  PhotoMapAppDelegate.h
//  PhotoMap
//
//  Created by Jernej Fijačko on 26.9.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyMapController.h"

@interface PhotoMapAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	MyMapController *controller;
	UINavigationController *navigation;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

