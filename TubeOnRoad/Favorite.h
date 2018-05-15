//
//  Favorite.h
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 11/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class VideoInfo;

@interface Favorite : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) VideoInfo *videoInfo;

@end
