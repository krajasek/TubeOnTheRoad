//
//  YTPlayerViewController.m
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 11/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTPlayerViewController.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import "ToRAppDelegate.h"
#import "VideoInfo.h"
#import "Favorite+Extension.h"

@interface YTPlayerViewController ()

@end

@implementation YTPlayerViewController
@synthesize webView = _webView;
@synthesize videoID = _videoID;
@synthesize videoImageView = _videoImageView;
@synthesize videoTitleLabel = _videoTitleLabel;
@synthesize videoDurationLabel = _videoDurationLabel;
@synthesize videoUploaderLabel = _videoUploaderLabel;
@synthesize videoDetails =_videoDetails;
@synthesize favButton = _favButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    [self.favButton setTitle:@"In favorites" forState:UIControlStateDisabled];
    [self.favButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    // unpack and set the video details
    
    self.videoImageView.image = [self.videoDetails valueForKey:@"thumbnailImage"];
    self.videoID = [self.videoDetails valueForKey:@"videoID"];
    self.videoTitleLabel.text = [self.videoDetails valueForKey:@"videoTitle"];
    self.videoDurationLabel.text = [self.videoDetails valueForKey:@"videoDuration"];
    self.videoUploaderLabel.text = [self.videoDetails valueForKey:@"uploaderName"];

    // Do any additional setup after loading the view.
    self.webView.delegate = self;
    self.webView.hidden = YES;
    self.webView.mediaPlaybackRequiresUserAction=NO;
    
    NSURL *playerurl = [[NSBundle mainBundle] URLForResource:@"player" withExtension:@"html"];
    
    NSString *playerStr = [NSString stringWithContentsOfURL:playerurl encoding:NSUTF8StringEncoding error:NULL];
    
    NSString *playerStrWithVideoID = [NSString stringWithFormat:playerStr,self.videoID] ;
    
    NSLog(@"html:%@",playerStrWithVideoID);
    [self.webView loadHTMLString:playerStrWithVideoID baseURL:[NSURL URLWithString:@"http://www.youtube.com"]];    
    
    // check if video already exists in favorites
    ToRAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    if ([Favorite existsWithVideoId:self.videoID inManagedObjectContext:appDelegate.managedObjectContext]) {
        self.favButton.enabled = NO;
    }
      
}

-(void) viewDidAppear:(BOOL)animated
{
    
    ToRAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    appDelegate.voicePlayInViewController = self;
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    
    ToRAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    appDelegate.voicePlayInViewController = nil;
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString;
    urlString = [request.URL absoluteString];
    NSLog(@"path:%@",urlString);
    
    if ([urlString isEqualToString:@"callback://stopVideo"]) {
        NSLog(@"end of playback...");
        return NO;
    }
    else if ([urlString isEqualToString:@"callback://pauseVideo"]) {
        NSLog(@"pause of playback...");
        return NO;
    
    }
    else if ([urlString isEqualToString:@"callback://newstate"]) {
        NSLog(@"new state event fired...");
        return NO;
    }
    else
        return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"in finish load...");   
    //[self.playerLoadIndicator stopAnimating];
    // [self.webView stringByEvaluatingJavaScriptFromString:@"stopVideo()"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"failed to load webview...%@",[error localizedDescription]);
}
                                          
                                          
                                          

                                          
- (void)viewDidUnload
{
    
    self.webView.delegate = nil;
    [self setVideoID:nil];
    [self setWebView:nil];
    [self setVideoImageView:nil];
    [self setVideoTitleLabel:nil];
    [self setVideoDurationLabel:nil];
    [self setVideoUploaderLabel:nil];
    [self setVideoDetails:nil];
    [self setFavButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)favButtonTouched:(UIButton *)sender {
    
    
    ToRAppDelegate *appDelegete = [UIApplication sharedApplication].delegate;
  
    VideoInfo *videoInfo = [NSEntityDescription insertNewObjectForEntityForName:@"VideoInfo" inManagedObjectContext:appDelegete.managedObjectContext];
    
    videoInfo.videoID = [self.videoDetails valueForKey:@"videoID"];
    
    videoInfo.videoTitle = [self.videoDetails valueForKey:@"videoTitle"];
    
    videoInfo.uploaderName = [self.videoDetails valueForKey:@"uploaderName"];
    
    videoInfo.duration = [NSNumber numberWithInteger:[[self.videoDetails valueForKey:@"videoDuration"] integerValue]];
    
    videoInfo.thumbnailURL = [self.videoDetails valueForKey:@"thumbnailURL"];
    
    videoInfo.thumbnailImage = UIImagePNGRepresentation([self.videoDetails valueForKey:@"thumbnailImage"]);
    
    videoInfo.creationDate = [NSDate date];
    
    Favorite *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"Favorite" inManagedObjectContext:appDelegete.managedObjectContext];
    
    favorite.creationDate = [NSDate date];
    favorite.videoInfo = videoInfo;

    sender.enabled = NO;        
    
}

- (IBAction)playButtonTouched:(id)sender {
    
    if (self.webView) {
        NSString *jsCall = [NSString stringWithFormat:@"loadVideoById('%@')",self.videoID];
        NSLog(@"play js call:%@",jsCall);
        
        [self.webView stringByEvaluatingJavaScriptFromString:jsCall];
    }
}



@end
