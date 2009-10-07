//
//  PhotoLocation.m
//  PhotoMap
//
//  Created by Jernej Fijačko on 27.9.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PhotoLocation.h"


@implementation PhotoLocation
@synthesize title, subtitle, photoPath, photoId, photoURL, size, smallPhotoURL;

- (void)dealloc {
	[smallPhotoURL release];
	[photoURL release];
	[title release];
    [subtitle release];
	[photoPath release];
    [super dealloc];
}

@end
