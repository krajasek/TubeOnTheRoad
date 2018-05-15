//
//  ToRSearchViewController.h
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 11/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTVideoData.h"

@interface ToRSearchViewController : UIViewController <UISearchBarDelegate,YTSearchDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *videoData;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@property (nonatomic, strong) YTVideoData *ytdata;



@end
