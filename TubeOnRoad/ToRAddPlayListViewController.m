//
//  ToRAddPlayListViewController.m
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 11/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ToRAddPlayListViewController.h"
#import "ToRAppDelegate.h"
#import "Playlist.h"

@interface ToRAddPlayListViewController ()

-(void) savePlayList;
@end

@implementation ToRAddPlayListViewController
@synthesize nameField;
@synthesize descriptionField;
@synthesize cancelButton;
@synthesize doneButton;

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

	// Do any additional setup after loading the view.
    
    
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


- (IBAction)cancelButtonTouched:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonTouched:(id)sender {
    [self savePlayList];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) savePlayList
{
    ToRAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    Playlist *playList = [NSEntityDescription insertNewObjectForEntityForName:@"Playlist" inManagedObjectContext:appDelegate.managedObjectContext];

    playList.name = self.nameField.text;
    playList.detailDescription = self.descriptionField.text;
    
}

- (void)viewDidUnload
{
    [self setDoneButton:nil];
    [self setCancelButton:nil];
    [self setNameField:nil];
    [self setDescriptionField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
