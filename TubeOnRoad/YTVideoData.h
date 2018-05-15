//
//  YTVideoData.h
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 10/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTConstants.h"
#import "YTSearchDelegate.h"

@interface YTVideoData : NSObject

@property (nonatomic, strong) NSArray *videoData;

- (BOOL) doSearchWithURLString:(NSString *) urlString ;

- (NSString *) constructURLForSearch:(NSString *)searchTerm orderBy:(NSString *)order startIndex:(int) startIndex maxResults:(int) maxResults;

- (NSArray *) contentFromData:(NSData *) videoData ;

@property (nonatomic, assign) id <YTSearchDelegate> delegate;

@end
