//
//  MyImageController.h
//  PhotoMap
//
//  Created by Jernej Fijačko on 27.9.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyImageController : UIViewController <UIScrollViewDelegate> {
	NSString *imagePath;
	UIScrollView *scrollView;
	UIView *containerView;
}
@property (nonatomic, copy) NSString *imagePath;

@end
