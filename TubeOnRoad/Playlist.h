//
//  Playlist.h
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 11/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class VideoInfo;

@interface Playlist : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * detailDescription;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *videos;
@end

@interface Playlist (CoreDataGeneratedAccessors)

- (void)addVideosObject:(VideoInfo *)value;
- (void)removeVideosObject:(VideoInfo *)value;
- (void)addVideos:(NSSet *)values;
- (void)removeVideos:(NSSet *)values;

@end
