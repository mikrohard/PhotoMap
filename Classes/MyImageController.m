//
//  MyImageController.m
//  PhotoMap
//
//  Created by Jernej Fijačko on 27.9.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyImageController.h"


@implementation MyImageController
@synthesize imagePath;

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
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.navigationController.navigationBar.translucent = YES;
	
	NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
	UIImage *image = [UIImage imageWithData:imageData];
	
	scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	CGRect frame;
	CGRect imageFrame;
	if(image.size.width > image.size.height)
	{
		scrollView.minimumZoomScale = 320 / image.size.width;
		frame = CGRectMake(0, 0, image.size.width, image.size.width);
		imageFrame = CGRectMake(0, (image.size.width - image.size.height)/2, image.size.width, image.size.height);
	}
	else
	{
		scrollView.minimumZoomScale = 460 / image.size.height;
		frame = CGRectMake(0, 0, image.size.height, image.size.height);
		imageFrame = CGRectMake((image.size.height - image.size.width)/2, 0, image.size.width, image.size.height);
	}
	
	 
	containerView = [[UIView alloc] initWithFrame:frame];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	imageView.frame = imageFrame;
	[containerView addSubview:imageView];

	[scrollView addSubview:containerView];
	scrollView.contentSize = containerView.frame.size;
	scrollView.delegate = self;
	scrollView.backgroundColor = [UIColor darkGrayColor];

	
	self.view = scrollView;
	[imageView release];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	[scrollView setZoomScale:scrollView.minimumZoomScale animated:NO];
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

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return containerView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)dealloc {
	[scrollView release];
	[containerView release];
	[imagePath release];
    [super dealloc];
}


@end
