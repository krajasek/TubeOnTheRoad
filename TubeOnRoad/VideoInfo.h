//
//  VideoInfo.h
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 11/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Favorite, Playlist;

@interface VideoInfo : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSData * thumbnailImage;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * uploaderName;
@property (nonatomic, retain) NSString * videoDescription;
@property (nonatomic, retain) NSString * videoID;
@property (nonatomic, retain) NSString * videoTitle;
@property (nonatomic, retain) Favorite *favoriteVideo;
@property (nonatomic, retain) NSSet *playLists;
@end

@interface VideoInfo (CoreDataGeneratedAccessors)

- (void)addPlayListsObject:(Playlist *)value;
- (void)removePlayListsObject:(Playlist *)value;
- (void)addPlayLists:(NSSet *)values;
- (void)removePlayLists:(NSSet *)values;

@end
