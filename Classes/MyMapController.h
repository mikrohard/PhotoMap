//
//  MyMapController.h
//  PhotoMap
//
//  Created by Jernej Fijačko on 26.9.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Three20/Three20.h>
#import "PhotoHandler.h"
#import "PhotoLocation.h"
#import "MyImageController.h"
#import "MockPhotoSource.h"
#import "PhotoViewController.h"

@interface MyMapController : UIViewController <MKMapViewDelegate, PhotoHandlerDelegate> {
	NSArray				*locations;
	MKMapView			*myMap;
	NSOperationQueue	*operationQueue;
	UIProgressView		*loadingProgress;
}
@property (nonatomic, retain) NSOperationQueue *operationQueue;
@property (nonatomic, retain) MKMapView *myMap;
@property (nonatomic, retain) NSArray *locations;

-(MKCoordinateRegion)calculateRegionForAnnotations:(NSArray *)annotations;

@end
