//
//  PhotoHandler.h
//  PhotoMap
//
//  Created by Jernej Fijačko on 26.9.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "EXF.h"
#import "PhotoLocation.h"

@interface PhotoHandler : NSObject {
	NSArray		*myPictures;
	id			delegate;
}
@property (nonatomic, retain) NSArray *myPictures;
@property (nonatomic, assign) id delegate;

-(void)getPhotoNames;
-(NSString *)photoDirectory;
-(NSArray *)allPhotoLocations;

@end

@protocol PhotoHandlerDelegate <NSObject>

@optional
-(void)pictureLoadingProgress:(float)progress;

@end
