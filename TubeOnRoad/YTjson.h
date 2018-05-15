//
//  YTjson.h
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 11/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTjson : NSObject

+ (NSString *) titleFromVideoData:(NSArray *)videoData atIndex:(NSInteger) index;

+ (NSString *) uploaderFromVideoData:(NSArray *)videoData atIndex:(NSInteger) index;
    
+ (NSString *) viewCountFromVideoData:(NSArray *)videoData atIndex:(NSInteger) index;

+ (NSString *) durationFromVideoData:(NSArray *)videoData atIndex:(NSInteger) index;

+ (NSString *) thumbnailURLFromVideoData:(NSArray *)videoData atIndex:(NSInteger) index;

+ (NSString *) videoIDFromVideoData:(NSArray *)videoData atIndex:(NSInteger) index;

@end
