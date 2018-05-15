//
//  ToRAppDelegate.h
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 11/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToRVoiceController;
@interface ToRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly, strong, nonatomic) ToRVoiceController *voiceController;

@property (strong, nonatomic) UIViewController *voicePlayInViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
