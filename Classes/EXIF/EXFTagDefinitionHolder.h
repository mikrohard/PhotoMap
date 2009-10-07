//
//  EXFTagDefinition.h
//  iphone-test
//
//  Created by steve woodcock on 26/03/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "EXFConstants.h"

@interface EXFTagDefinitionHolder :NSObject {

NSMutableDictionary* definitions;
}
 
@property (readwrite, retain) NSMutableDictionary* definitions;

-(void) addTagDefinition: (EXFTag*) aTagDefinition forKey: (NSNumber*) aTagKey;

@end



