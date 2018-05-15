//
//  ToRSearchViewController.m
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 11/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ToRSearchViewController.h"
#import "YTPlayerViewController.h"
#import "Favorite.h"
#import "VideoInfo.h"
#import "ToRAppDelegate.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import "ToRVoiceController.h"
#import "YTjson.h"

@interface ToRSearchViewController ()



- (void) setAllDelegates;
- (void) unsetAllDelegates;



@end

@implementation ToRSearchViewController
@synthesize searchBar = _searchBar;
@synthesize searchTableView = _searchTableView;
@synthesize  ytdata = _ytdata;
@synthesize videoData = _videoData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (YTVideoData *) ytdata
{
    if (!_ytdata)
        _ytdata = [[YTVideoData alloc] init];
    
    return _ytdata;
}

- (void) setAllDelegates
{
    self.searchBar.delegate = self;
    self.ytdata.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.delegate = self;
    
    
}

- (void) unsetAllDelegates
{
    self.searchBar.delegate = nil;
    self.ytdata.delegate = nil;
    self.searchTableView.dataSource = nil;
    self.searchTableView.delegate = nil;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setAllDelegates];

    /* This is undocumented and should not be used in the app
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(youTubeVideoExit:) 
                                                 name:@"UIMoviePlayerControllerDidExitFullscreenNotification"
                                               object:nil];    
    */ 
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

- (void)viewDidUnload
{
    [self unsetAllDelegates];
    [self setSearchBar:nil];
    [self setSearchTableView:nil];
    [self setVideoData:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSLog(@"search text:%@",searchBar.text);

    NSString *returnURL = [self.ytdata constructURLForSearch:searchBar.text orderBy:[NSString stringWithUTF8String:kDefaultOrder] startIndex:1 maxResults:kMaxSearchResults];
    
    BOOL searchStarted = [self.ytdata doSearchWithURLString:returnURL];
    if (searchStarted)
        NSLog(@"search started");
    else 
        NSLog(@"search failed");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        [searchBar resignFirstResponder];
        self.videoData = nil;
        [self.searchTableView reloadData];

    }    
}


- (void) searchCompletedWithResult:(NSArray *)content andFlag:(BOOL)resultFlag {
    
    NSLog(@"YT search delegate callback");
    if (resultFlag) {
        
        self.videoData = [NSArray arrayWithArray:content];
        NSLog(@"count of received content:%d",[self.videoData count]);
        
        // Stuff the search results to the voice controller
        
        ToRAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        if (appDelegate.voiceController) {
            appDelegate.voiceController.searchList = self.videoData;
        }

        [self.searchTableView reloadData];
        NSLog(@"reloading data...");
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.videoData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"YTData";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    UILabel *videoTitleLabelInCell = (UILabel *)[cell.contentView viewWithTag:102];
    videoTitleLabelInCell.text = [YTjson titleFromVideoData:self.videoData atIndex:indexPath.row]; 

    UILabel *uploaderLabelInCell = (UILabel *)[cell.contentView viewWithTag:105];
    uploaderLabelInCell.text = [YTjson uploaderFromVideoData:self.videoData atIndex:indexPath.row]; 

    UILabel *viewCountLabelInCell = (UILabel *)[cell.contentView viewWithTag:103];
    viewCountLabelInCell.text = [YTjson viewCountFromVideoData:self.videoData atIndex:indexPath.row]; 

    UILabel *durationLabelInCell = (UILabel *)[cell.contentView viewWithTag:104];
    durationLabelInCell.text = [YTjson durationFromVideoData:self.videoData atIndex:indexPath.row]; 

    UIImageView *thumbnailImageViewInCell = (UIImageView *) [cell.contentView viewWithTag:101];

  
    // Download thumbnail url for the video
    
    NSString *thumbnailurl = [YTjson thumbnailURLFromVideoData:self.videoData atIndex:indexPath.row]; 
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:thumbnailurl]];          

    //TBD: This image is not getting cleared when searching on other videos... Need to clean up the images before searching on other videos
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *imageData, NSError *error) {
        if (imageData) {
            thumbnailImageViewInCell.image = [UIImage imageWithData:imageData];
        }            
    
    }];
        
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
*/

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    UITableViewCell *selectedCell = [self.searchTableView cellForRowAtIndexPath:self.searchTableView.indexPathForSelectedRow];

    YTPlayerViewController *ytController = segue.destinationViewController;
    if (ytController) {
        ytController.videoID = [NSString stringWithString:[YTjson videoIDFromVideoData:self.videoData atIndex:self.searchTableView.indexPathForSelectedRow.row]];

        
        NSMutableDictionary *videoDetails = [[NSMutableDictionary alloc] init];

        [videoDetails setObject:[YTjson videoIDFromVideoData:self.videoData atIndex:self.searchTableView.indexPathForSelectedRow.row] forKey:@"videoID"];
        
        UIImageView *thumbnailImageViewInCell = (UIImageView *) [selectedCell.contentView viewWithTag:101];
                
        [videoDetails setObject:thumbnailImageViewInCell.image forKey:@"thumbnailImage"];
        
        [videoDetails setObject:[YTjson thumbnailURLFromVideoData:self.videoData atIndex:self.searchTableView.indexPathForSelectedRow.row] forKey:@"thumbnailURL"];
        
        [videoDetails setObject:[YTjson titleFromVideoData:self.videoData atIndex:self.searchTableView.indexPathForSelectedRow.row] forKey:@"videoTitle"];
        
        [videoDetails setObject:[YTjson durationFromVideoData:self.videoData atIndex:self.searchTableView.indexPathForSelectedRow.row] forKey:@"videoDuration"];
        
        [videoDetails setObject:[YTjson uploaderFromVideoData:self.videoData atIndex:self.searchTableView.indexPathForSelectedRow.row] forKey:@"uploaderName"];
        
        ytController.videoDetails = videoDetails;
    }
    
}
@end
