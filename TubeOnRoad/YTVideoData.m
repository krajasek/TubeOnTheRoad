//
//  YTVideoData.m
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 10/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTVideoData.h"


@interface YTVideoData ()

@property (nonatomic, strong) NSMutableData *responseData;


@end
@implementation YTVideoData

@synthesize videoData = _videoData;

@synthesize responseData = _responseData;

@synthesize delegate = _delegate;


- (NSString *) constructURLForSearch:(NSString *)searchTerm orderBy:(NSString *)order startIndex:(int) startIndex maxResults:(int) maxResults
{
    NSString *completeURL; 
    
    completeURL = [[NSString alloc] initWithFormat:@"%@?q=%@&orderby=%@&start-index=%d&max-results=%d&v=%@&alt=%@",[NSString stringWithUTF8String:kBaseSearchURL],searchTerm,order,startIndex,maxResults,[NSString stringWithUTF8String:kApiVersion],[NSString stringWithUTF8String:kDefaultResponseContentType]];
    
    return [completeURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
- (BOOL) doSearchWithURLString:(NSString *) urlString {
  
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (conn) {
        self.responseData = [[NSMutableData alloc] init];
        return YES;
    }
    else {
        return NO;
    }
}

- (NSArray *) contentFromData:(NSData *) videoData {
    
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:videoData options:NSJSONReadingMutableContainers error:nil]; 
    
    NSArray *contentList = [jsonData valueForKeyPath:@"feed.entry"];
    
    for(NSDictionary *content in contentList) {
        
        NSString *title = [content valueForKeyPath:@"title.$t"];
        NSString *videoURL = [content valueForKeyPath:@"media$group.media$content[1].url"];
        NSLog(@"title:%@\n video:%@\n-----\n",title,videoURL);
    }
    return contentList;
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    NSLog(@"connected to video search API URL...");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    
    if (data) {
        [self.responseData appendData:data];
        NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
        

        NSLog(@".");
    }
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    if (self.delegate)
        [self.delegate searchCompletedWithResult:nil andFlag:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    self.videoData = [self contentFromData:self.responseData];
    NSLog(@"count of self.videoData:%d",[self.videoData count]); 
    if (self.delegate)
        [self.delegate searchCompletedWithResult:self.videoData andFlag:YES];
    
}

- (void) dealloc {
    [self setResponseData:nil];
    [self setVideoData:nil];
    
}
@end
