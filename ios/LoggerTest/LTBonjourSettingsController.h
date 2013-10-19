//
//  LTBonjourSettingsController.h
//  LoggerTest
//
//  Created by Florent Pillet on 10/6/13.
//  Copyright (c) 2013 Florent Pillet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTBonjourSettingsController : UIViewController

@property (weak, nonatomic) IBOutlet UISwitch *useBonjour;
@property (weak, nonatomic) IBOutlet UISwitch *localDomainOnly;
@property (weak, nonatomic) IBOutlet UITextField *bonjourServiceName;

- (IBAction)bonjourServiceNameChanged:(id)sender;
- (IBAction)booleanChanged:(id)sender;

@end
