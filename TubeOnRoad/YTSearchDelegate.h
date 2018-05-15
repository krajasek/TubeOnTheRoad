//
//  YTSearchDelegate.h
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 10/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YTSearchDelegate <NSObject>

@required
- (void) searchCompletedWithResult:(NSArray *)videoData  andFlag:(BOOL)resultFlag;
@end
