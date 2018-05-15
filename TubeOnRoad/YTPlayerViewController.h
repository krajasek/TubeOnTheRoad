//
//  YTPlayerViewController.h
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 11/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTPlayerViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSString *videoID;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *videoDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoUploaderLabel;


@property (nonatomic, strong) NSDictionary *videoDetails;

@property (weak, nonatomic) IBOutlet UIButton *favButton;

- (IBAction)favButtonTouched:(id)sender;
- (IBAction)playButtonTouched:(id)sender;

@end
