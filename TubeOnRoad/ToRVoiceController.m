//
//  ToRVoiceController.m
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 11/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ToRVoiceController.h"
#import <OpenEars/LanguageModelGenerator.h>
#import <OpenEars/OpenEarsLogging.h>
#import <OpenEars/AudioSessionManager.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import "Favorite+Extension.h"
#import "VideoInfo.h"
#import "ToRAppDelegate.h"
#import "YTjson.h"

@interface ToRVoiceController()

-(void) playFavorites;
-(void) playSearchResults;

-(void) playVideoById:(NSString *) videoId;
-(void) playFirstFavorite;
-(void) playNextFavorite;
-(void) playPreviousFavorite;
-(void) playLastFavorite;

-(void) playFirstSearchResult;
-(void) playNextSearchResult;
-(void) playPreviousSearchResult;
-(void) playLastSearchResult;

-(void) playVideo;
-(void) pauseVideo;

@end

@implementation ToRVoiceController

@synthesize pocketsphinxController = _pocketsphinxController;
@synthesize openEarsEventsObserver = _openEarsEventsObserver;
@synthesize lmPath = _lmPath;
@synthesize dictPath = _dictPath;
@synthesize voicePlayWebView = _voicePlayWebView;
@synthesize appDelegate = _appDelegate;
@synthesize searchList = _searchList;

NSInteger favCurrentIndex;
NSInteger searchCurrentIndex;

NSArray *favoriteList;


BOOL isPlayerReady;

typedef enum
{
    kFavorite,
    kSearch,
    kPlaylist
} VoicePlayContext;

VoicePlayContext voicePlayContext;

- (PocketsphinxController *)pocketsphinxController {
	if (_pocketsphinxController == nil) {
		_pocketsphinxController = [[PocketsphinxController alloc] init];
	}
	return _pocketsphinxController;
}

- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (_openEarsEventsObserver == nil) {
		_openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return _openEarsEventsObserver;
}

-(id) init
{
    self = [super init];
    
    if (self)
    {
        LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc] init];
        
        //Need a way to dynamically generate this words list to include playlists as well
        NSArray *words = [NSArray arrayWithObjects:@"PLAY", @"PAUSE", @"PLAY FAVORITES", @"PLAY FAVORITE", @"PLAY RESULTS", @"NEXT", @"PREVIOUS", @"FIRST", @"LAST", @"CLASSICAL MUSIC", @"ILAYARAJA", nil];
        NSString *name = @"ToRLanguageModel";
        NSError *err = [lmGenerator generateLanguageModelFromArray:words withFilesNamed:name];
        
        
        NSDictionary *languageGeneratorResults = nil;
        
        if([err code] == noErr) {
            
            languageGeneratorResults = [err userInfo];
            
            self.lmPath = [languageGeneratorResults objectForKey:@"LMPath"];
            self.dictPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];
            NSLog(@"language model created...");
            
        } else {
            NSLog(@"Error: %@",[err localizedDescription]);
        }
        
    [self.openEarsEventsObserver setDelegate:self];  
    self.voicePlayWebView = [[UIWebView alloc] init];
    self.voicePlayWebView.mediaPlaybackRequiresUserAction = NO;
    self.voicePlayWebView.hidden = YES;
    self.voicePlayWebView.delegate = self;
    self.appDelegate = [UIApplication sharedApplication].delegate; 
    favCurrentIndex = -1;  
    isPlayerReady = NO;
    }
   
    return self;
}

-(void) dealloc
{
    [self setPocketsphinxController:nil];
    self.openEarsEventsObserver.delegate = nil;
    
    [self setOpenEarsEventsObserver:nil];
    [self setLmPath:nil];
    [self setDictPath:nil];
    self.voicePlayWebView.delegate = nil;
    [self setVoicePlayWebView:nil]; 
    [self setAppDelegate:nil];
    [self setSearchList:nil];
}

- (void) startVoiceEngine
{

    [self.pocketsphinxController startListeningWithLanguageModelAtPath:self.lmPath dictionaryAtPath:self.dictPath languageModelIsJSGF:NO];
    NSLog(@"after start listening...");
    AudioSessionManager *aud = [AudioSessionManager sharedAudioSessionManager];    
    aud.soundMixing = YES;
    NSLog(@"after sound mixing...");
    
}

- (void) stopVoiceEngine
{
    [self.pocketsphinxController stopListening];
}

-(void) turnLoggerOn
{
    [OpenEarsLogging startOpenEarsLogging];
    self.pocketsphinxController.verbosePocketSphinx = YES;

}

-(void) turnLoggerOff
{
    self.pocketsphinxController.verbosePocketSphinx = NO;    
}



- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
    
    if ([hypothesis isEqualToString:@"PLAY RESULTS"]) {
        
        voicePlayContext = kSearch;
        [self playSearchResults];

    }
    if ([hypothesis isEqualToString:@"PLAY FAVORITE"]||[hypothesis isEqualToString:@"PLAY FAVORITES"]) {

        voicePlayContext = kFavorite;
        [self playFavorites];
    }
    if ([hypothesis isEqualToString:@"NEXT"]) {    
     
        if (voicePlayContext == kFavorite)
            [self playNextFavorite];
        if (voicePlayContext == kSearch)
            [self playNextSearchResult];
    }
    if ([hypothesis isEqualToString:@"PREVIOUS"]) {    
        
        if (voicePlayContext == kFavorite)
            [self playPreviousFavorite];
        if (voicePlayContext == kSearch)
            [self playPreviousSearchResult];
    }
    if ([hypothesis isEqualToString:@"FIRST"]) {    
        
        if (voicePlayContext == kFavorite)
            [self playFirstFavorite];
        if (voicePlayContext == kSearch)
            [self playFirstSearchResult];
    }
    if ([hypothesis isEqualToString:@"LAST"]) {    
        
        if (voicePlayContext == kFavorite)
            [self playLastFavorite];
        if (voicePlayContext == kSearch)
            [self playLastSearchResult];
    }
    if ([hypothesis isEqualToString:@"PAUSE"]) {
     
        if (searchCurrentIndex > -1 || favCurrentIndex > -1) {
            [self pauseVideo];
        }
    }
    if ([hypothesis isEqualToString:@"PLAY"]) {
        
        if (searchCurrentIndex > -1 || favCurrentIndex > -1) {
            [self playVideo];
        }
    }
}

-(void) pauseVideo
{
    [self.voicePlayWebView stringByEvaluatingJavaScriptFromString:@"pauseVideo()"];
}

-(void) playVideo
{
    [self.voicePlayWebView stringByEvaluatingJavaScriptFromString:@"playVideo()"];
}
-(void) playSearchResults
{
    [self playFirstSearchResult];
}
-(void) playFavorites
{
    favoriteList = [Favorite listOfVideoIdsWithContext:self.appDelegate.managedObjectContext];
    [self playFirstFavorite];
}

-(void) playFirstFavorite
{
    if (favoriteList) {

        if ([favoriteList count] > 0) {
            favCurrentIndex = 0;
            Favorite *favorite = [favoriteList objectAtIndex:favCurrentIndex];
            if (favorite) 
                [self playVideoById:favorite.videoInfo.videoID];
        } 
    }
    
}

-(void) playNextFavorite
{
    NSInteger listCount;
    if (favoriteList) {
        
        listCount = [favoriteList count];
        if (listCount > 0 && favCurrentIndex < listCount - 1) {
            favCurrentIndex++;
            Favorite *favorite = [favoriteList objectAtIndex:favCurrentIndex];
            if (favorite)
                [self playVideoById:favorite.videoInfo.videoID];
        }
    }
}

-(void) playPreviousFavorite
{
    NSInteger listCount;
    
    if (favoriteList) {
        
        listCount = [favoriteList count];
        if (listCount > 0 && favCurrentIndex > 0) {
            favCurrentIndex--;
            Favorite *favorite = [favoriteList objectAtIndex:favCurrentIndex];
            if (favorite)
                [self playVideoById:favorite.videoInfo.videoID];
        }
    }
}
-(void) playLastFavorite
{
    NSInteger listCount;
    if (favoriteList) {
        listCount = [favoriteList count];
        if (listCount > 0) {
            favCurrentIndex = listCount - 1;
            Favorite *favorite = [favoriteList lastObject];
            if (favorite)
                [self playVideoById:favorite.videoInfo.videoID];
        } 
    }

}

-(void) playFirstSearchResult
{

    if (self.searchList) {
        if ([self.searchList count] > 0) {
             searchCurrentIndex = 0;
            [self playVideoById:[YTjson videoIDFromVideoData:self.searchList atIndex:searchCurrentIndex]];
        }
    }    
    
}
-(void) playNextSearchResult
{

    NSInteger listCount;
    
    if (self.searchList) {
        
        listCount = [self.searchList count];
        if (listCount > 0 && searchCurrentIndex < listCount - 1) {
            searchCurrentIndex++;
            [self playVideoById:[YTjson videoIDFromVideoData:self.searchList atIndex:searchCurrentIndex]];

        }
    }
}
-(void) playPreviousSearchResult
{
    NSInteger listCount;
    
    if (self.searchList) {
       
        listCount = [self.searchList count];    
        if (listCount > 0 && searchCurrentIndex >0) {
             searchCurrentIndex--;
            [self playVideoById:[YTjson videoIDFromVideoData:self.searchList atIndex:searchCurrentIndex]];

        }
        else {
            searchCurrentIndex = -1;
        }
    }

}
-(void) playLastSearchResult
{
    NSInteger listCount;
    
    if (self.searchList) {
        listCount = [self.searchList count];        
        if (listCount > 0) {
            searchCurrentIndex = listCount - 1;
            [self playVideoById:[YTjson videoIDFromVideoData:self.searchList atIndex:searchCurrentIndex]];

        } 
    }

    
}

-(void) playVideoById:(NSString *)videoId
{
    if (self.appDelegate.voicePlayInViewController)
    {
        if (![[self.appDelegate.voicePlayInViewController.view subviews] containsObject:self.voicePlayWebView]) {
            [self.appDelegate.voicePlayInViewController.view addSubview:self.voicePlayWebView];
        }
        if (!isPlayerReady) {
            NSURL *playerurl = [[NSBundle mainBundle] URLForResource:@"player" withExtension:@"html"];
            
            NSString *playerStr = [NSString stringWithContentsOfURL:playerurl encoding:NSUTF8StringEncoding error:NULL];
            
            NSString *playerStrWithVideoID = [NSString stringWithFormat:playerStr,videoId] ;
            [self.voicePlayWebView loadHTMLString:playerStrWithVideoID baseURL:[NSURL URLWithString:@"http://www.youtube.com"]];    
            isPlayerReady = YES;
        }
        else {
            NSLog(@"wow.... the player is not loaded every time!");
            [self.voicePlayWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"loadVideoById('%@')",videoId]];
        }
    }

    
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

// end of junk test code

- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started.");
}

- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete.");
}

- (void) pocketsphinxDidStartListening {
	NSLog(@"Pocketsphinx is now listening.");
}

- (void) pocketsphinxDidDetectSpeech {
	NSLog(@"Pocketsphinx has detected speech.");
}

- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
}

- (void) pocketsphinxDidStopListening {
	NSLog(@"Pocketsphinx has stopped listening.");
}

- (void) pocketsphinxDidSuspendRecognition {
	NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void) pocketsphinxDidResumeRecognition {
	NSLog(@"Pocketsphinx has resumed recognition."); 
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void) pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OpenEarsLogging to learn more.");
}

// An optional delegate method of OpenEarsEventsObserver which informs that there was an interruption to the audio session (e.g. an incoming phone call).
- (void) audioSessionInterruptionDidBegin {
	NSLog(@"AudioSession interruption began."); // Log it.
	[self.pocketsphinxController stopListening]; // React to it by telling Pocketsphinx to stop listening since it will need to restart its loop after an interruption.
}

// An optional delegate method of OpenEarsEventsObserver which informs that the interruption to the audio session ended.
- (void) audioSessionInterruptionDidEnd {
	NSLog(@"AudioSession interruption ended."); // Log it.
    // We're restarting the previously-stopped listening loop.
    //  [self startListening];
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:self.lmPath dictionaryAtPath:self.dictPath languageModelIsJSGF:NO];
    
	
}

// An optional delegate method of OpenEarsEventsObserver which informs that the audio input became unavailable.
- (void) audioInputDidBecomeUnavailable {
	NSLog(@"The audio input has become unavailable"); // Log it.
	[self.pocketsphinxController stopListening]; // React to it by telling Pocketsphinx to stop listening since there is no available input
}

// An optional delegate method of OpenEarsEventsObserver which informs that the unavailable audio input became available again.
- (void) audioInputDidBecomeAvailable {
	NSLog(@"The audio input is available"); // Log it.
    //    [self startListening];
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:self.lmPath dictionaryAtPath:self.dictPath languageModelIsJSGF:NO];
    
}

// An optional delegate method of OpenEarsEventsObserver which informs that there was a change to the audio route (e.g. headphones were plugged in or unplugged).
- (void) audioRouteDidChangeToRoute:(NSString *)newRoute {
	NSLog(@"Audio route change. The new audio route is %@", newRoute); // Log it.
	[self.pocketsphinxController stopListening]; // React to it by telling the Pocketsphinx loop to shut down and then start listening again on the new route
    NSLog(@"lmpath: %@",self.lmPath);
    NSLog(@"dicpath:%@",self.dictPath);
    
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:self.lmPath dictionaryAtPath:self.dictPath languageModelIsJSGF:NO];
    
    //    [self startListening];
}

// An optional delegate method of OpenEarsEventsObserver which informs that the Pocketsphinx recognition loop has entered its actual loop.
// This might be useful in debugging a conflict between another sound class and Pocketsphinx.
- (void) pocketsphinxRecognitionLoopDidStart {
    
	NSLog(@"Pocketsphinx recognition loop is starting up."); // Log it.
    
}




@end

