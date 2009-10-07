//
//  MyMapController.m
//  PhotoMap
//
//  Created by Jernej Fijačko on 26.9.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyMapController.h"


@implementation MyMapController
@synthesize locations, myMap, operationQueue;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
	self.myMap = [[MKMapView alloc] initWithFrame:frame];
	self.myMap.delegate = self;
	self.view = myMap;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
	self.navigationController.toolbar.barStyle = UIBarStyleBlack;
	self.navigationController.toolbar.translucent = YES;
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[self.navigationController setToolbarHidden:NO animated:NO];
	loadingProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
	loadingProgress.frame = CGRectMake(40, 17, 240, 40);
	[self.navigationController.toolbar addSubview:loadingProgress];
	
	self.operationQueue = [[[NSOperationQueue alloc] init] autorelease];
	
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(getPhotoLocations:) object:nil];
	
	[operationQueue addOperation:operation];
	
}

-(void)getPhotoLocations:(NSDictionary*)data {
	PhotoHandler *myHandler = [[PhotoHandler alloc] init];
	
	myHandler.delegate = self;
	
	self.locations = [myHandler allPhotoLocations];
		
	[myHandler release];
	
	[self.myMap performSelectorOnMainThread:@selector(addAnnotations:) withObject:locations waitUntilDone:NO];
	[self performSelectorOnMainThread:@selector(zoomiraj:) withObject:locations waitUntilDone:NO];
}

-(void)pictureLoadingProgress:(float)progress {
	NSLog(@"Progress: %.2f", progress);
	NSNumber *number = [NSNumber numberWithFloat:progress];
	[self performSelectorOnMainThread:@selector(setProgress:) withObject:number waitUntilDone:NO];
}

- (void)setProgress:(NSNumber *)progress {
	loadingProgress.progress = [progress floatValue];
}

-(void)zoomiraj:(NSArray *)lokacije {
	[self.navigationController setToolbarHidden:YES animated:NO];
	MKCoordinateRegion regija = [self calculateRegionForAnnotations:lokacije];
	[self.myMap setRegion:regija animated:YES];
}

-(MKCoordinateRegion)calculateRegionForAnnotations:(NSArray *)annotations {
	
	float min_lat = 0;
	float max_lat = 0;
	float min_lon = 0;
	float max_lon = 0;
	
	for(id<MKAnnotation> annotation in annotations)
	{
		if(min_lat == 0)
		{
			min_lat = annotation.coordinate.latitude;
		}
		else if(annotation.coordinate.latitude < min_lat)
		{
			min_lat = annotation.coordinate.latitude;
		}
		
		if(min_lon == 0)
		{
			min_lon = annotation.coordinate.longitude;
		}
		else if(annotation.coordinate.longitude < min_lon)
		{
			min_lon = annotation.coordinate.longitude;
		}
		
		if(max_lat == 0)
		{
			max_lat = annotation.coordinate.latitude;
		}
		else if(annotation.coordinate.latitude > max_lat)
		{
			max_lat = annotation.coordinate.latitude;
		}
		
		if(max_lon == 0)
		{
			max_lon = annotation.coordinate.longitude;
		}
		else if(annotation.coordinate.longitude > max_lon)
		{
			max_lon = annotation.coordinate.longitude;
		}
	}
	
	float center_lat = (min_lat + max_lat)/2;
	float lat_delta = max_lat - min_lat;
	if(lat_delta < 0)
		lat_delta = -lat_delta;
	NSLog(@"%.4f, %.4f", min_lat, max_lat);
	
	float center_lon = (min_lon + max_lon)/2;
	float lon_delta = max_lon - min_lon;
	if(lon_delta < 0)
		lon_delta = -lon_delta;
	
	NSLog(@"%.4f, %.4f, %.4f, %.4f", center_lat, center_lon, lat_delta, lon_delta);
	
	CLLocation *center = [[CLLocation alloc] initWithLatitude:center_lat longitude:center_lon];
	MKCoordinateSpan span = MKCoordinateSpanMake(lat_delta, lon_delta);
	MKCoordinateRegion region = MKCoordinateRegionMake(center.coordinate, span);
	
	return region;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"myAnnotation"];
	if (annotationView == nil) {
        annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"] autorelease];
    }
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	annotationView.canShowCallout = YES;
	annotationView.rightCalloutAccessoryView = button;
	
	return annotationView;
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	PhotoLocation *location = view.annotation;
//	NSString *path = location.photoPath;
//	NSLog(@"Gumbek bo prikazal %@", path);
	/*
	MyImageController *controller = [[MyImageController alloc] init];
	controller.imagePath = path;
	controller.title = location.title;
	 */
//	NSMutableArray *myPhotos = [[NSMutableArray alloc] init];
	
//	for(PhotoLocation *loc in locations)
//	{
//		MockPhoto *photo = [[MockPhoto alloc] initWithURL:loc.photoURL smallURL:loc.smallPhotoURL size:CGSizeMake(2048,1536)];
//		[myPhotos addObject:photo];
//		[photo release];
//	}
	
	MockPhoto *photo = [[MockPhoto alloc] initWithURL:location.photoURL smallURL:location.smallPhotoURL size:CGSizeMake(2048,1536)];
	NSArray *tempPhoto = [NSArray arrayWithObject:photo];
	
	
	MockPhotoSource *source = [[MockPhotoSource alloc] initWithType:MockPhotoSourceDelayed title:location.title photos:tempPhoto photos2:nil];
	
	PhotoViewController *controller = [[PhotoViewController alloc] initWithPhoto:photo];
	controller.photoSource = source;
//	controller.centerPhoto = [myPhotos objectAtIndex:location.photoId];
	
//	[myPhotos release];
	[photo release];
	[source release];
	
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)dealloc {
	[loadingProgress release];
	[operationQueue release];
	[myMap release];
	[locations release];
    [super dealloc];
}


@end
