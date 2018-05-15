//
//  Favorite+Extension.h
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 11/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Favorite.h"

@interface Favorite (Extension)

+ (BOOL) existsWithVideoId:(NSString *) videoID inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext;

+ (NSArray *) listOfVideoIdsWithContext:(NSManagedObjectContext *) managedObjectContext;
@end
