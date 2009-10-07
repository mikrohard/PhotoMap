//
//  PhotoHandler.m
//  PhotoMap
//
//  Created by Jernej Fijačko on 26.9.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PhotoHandler.h"

@implementation PhotoHandler
@synthesize myPictures, delegate;

-(void)getPhotoNames {
	NSFileManager *myManager = [NSFileManager defaultManager];
	self.myPictures = [myManager directoryContentsAtPath:[self photoDirectory]];
	[myManager release];
}

-(NSString *)photoDirectory {
	
	NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [dirs objectAtIndex:0];
	NSString *picturePath = [documentsPath stringByAppendingPathComponent:@"pictures"];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if(![fileManager directoryContentsAtPath:picturePath])
	{
		[fileManager createSymbolicLinkAtPath:picturePath pathContent:@"/var/mobile/Media/DCIM/100APPLE"];
	}
	return picturePath;
}

-(NSArray *)allPhotoLocations {
	
	if([self.myPictures count] == 0)
	{
		[self getPhotoNames];
	}
	
	NSArray *pictureNames = self.myPictures;
	NSMutableArray *tempLocations = [[NSMutableArray alloc] init];
	float stevilo_elementov = [pictureNames count];
	float i = 1;
	for(NSString *name in pictureNames)
	{
		//NSLog(name);
		NSString *directory = [self photoDirectory];
		NSString *path = [directory stringByAppendingPathComponent:name];
		if([[path pathExtension] isEqualToString:@"JPG"])
		{
			if([[NSFileManager defaultManager] fileExistsAtPath:path])
			{
				NSData *imageData = [[NSData alloc] initWithContentsOfFile:path];
				EXFJpeg *jpegScanner = [[EXFJpeg alloc] init];
				[jpegScanner scanImageData:imageData];
				EXFMetaData *exifData = jpegScanner.exifMetaData;
				
				NSString *timeStamp = [exifData tagValue:[NSNumber numberWithInt:EXIF_DateTime]];
				
				NSString *latRef = [exifData tagValue:[NSNumber numberWithInt:EXIF_GPSLatitudeRef]];
				
				NSString *lonRef = [exifData tagValue:[NSNumber numberWithInt:EXIF_GPSLongitudeRef]];
				
				EXFGPSLoc *latitude = [exifData tagValue:[NSNumber numberWithInt:EXIF_GPSLatitude]];
				
				double lat =  latitude.degrees.numerator*1.0 / latitude.degrees.denominator*1.0 + (latitude.minutes.numerator*1.0 / latitude.minutes.denominator*1.0 / 60.0) + (latitude.seconds.numerator*1.0 / latitude.seconds.denominator*1.0 / 3600.0);
				
				EXFGPSLoc *longitude = [exifData tagValue:[NSNumber numberWithInt:EXIF_GPSLongitude]];
				
				double lon =  longitude.degrees.numerator*1.0 / longitude.degrees.denominator*1.0 / 1.0 + (longitude.minutes.numerator*1.0 / longitude.minutes.denominator*1.0 / 60.0) + (longitude.seconds.numerator*1.0 / longitude.seconds.denominator*1.0 / 3600.0);
				
				if([latRef hasPrefix:@"S"])
				{
					lat = -lat;
				}
				
				if([lonRef hasPrefix:@"W"])
				{
					lon = -lon;
				}
				
		//		NSLog(@"%.6f, %.6f", lat, lon);
				
				if([latRef length] && [lonRef length])
				{
					PhotoLocation *location = [[PhotoLocation alloc] initWithLatitude:lat longitude:lon];
					location.photoId = [tempLocations count];
					location.title = name;
					location.subtitle = timeStamp;
					location.photoPath = path;
					location.photoURL = [@"documents://pictures/" stringByAppendingString:name];
					NSString *thumbName = [name stringByReplacingOccurrencesOfString:@"JPG" withString:@"THM"];
					location.smallPhotoURL = [@"documents://pictures/.MISC/" stringByAppendingString:thumbName];
					UIImage *tempImage = [[UIImage alloc] initWithData:imageData];
					location.size = tempImage.size;
					[tempImage release];
					[tempLocations addObject:location];
					[location release];
				}
				
				[jpegScanner release];
				[imageData release];
			}
		}
		if([self.delegate respondsToSelector:@selector(pictureLoadingProgress:)])
		{
			float progress = i/stevilo_elementov;
			[self.delegate pictureLoadingProgress:progress];
		}
		i++;
	}
	
	[tempLocations autorelease];
	
	return tempLocations;
}

-(void)dealloc {
	[myPictures release];
	[super dealloc];
}

@end
