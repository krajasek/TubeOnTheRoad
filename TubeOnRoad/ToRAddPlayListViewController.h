//
//  ToRAddPlayListViewController.h
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 11/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToRAddPlayListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)doneButtonTouched:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

- (IBAction)cancelButtonTouched:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet UITextField *descriptionField;

@end
