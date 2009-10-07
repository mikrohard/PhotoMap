//
//  PhotoLocation.h
//  PhotoMap
//
//  Created by Jernej Fijačko on 27.9.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PhotoLocation : CLLocation {
	NSString		*title;
	NSString		*subtitle;
	NSString		*photoPath;
	NSString		*photoURL;
	NSString		*smallPhotoURL;
	CGSize			size;
	int				photoId;
}
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *photoPath;
@property (nonatomic, copy) NSString *photoURL;
@property (nonatomic, copy) NSString *smallPhotoURL;
@property (assign) CGSize size;
@property (assign) int photoId;

@end
