//
//  ToRVoiceController.h
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 11/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/OpenEarsEventsObserver.h>

@class ToRAppDelegate;
@interface ToRVoiceController : NSObject <OpenEarsEventsObserverDelegate, UIWebViewDelegate>

@property (strong, nonatomic) PocketsphinxController *pocketsphinxController;

@property (strong, nonatomic) OpenEarsEventsObserver *openEarsEventsObserver;

@property (nonatomic, strong) NSString *lmPath;
@property (nonatomic, strong) NSString *dictPath;

@property (nonatomic, strong) UIWebView *voicePlayWebView;

@property (nonatomic, strong) ToRAppDelegate *appDelegate;

@property (nonatomic, strong) NSArray *searchList;

-(void) turnLoggerOn;
-(void) turnLoggerOff;

-(void) startVoiceEngine;

-(void) stopVoiceEngine;


@end
