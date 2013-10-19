//
//  LTDirectHostViewController.h
//  LoggerTest
//
//  Created by Florent Pillet on 10/6/13.
//  Copyright (c) 2013 Florent Pillet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTDirectHostViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *hostField;
@property (weak, nonatomic) IBOutlet UITextField *portField;
- (IBAction)hostDidChange:(id)sender;
- (IBAction)portDidChange:(id)sender;

@end
