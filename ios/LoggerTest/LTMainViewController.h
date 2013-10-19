//
//  LTMainViewController.h
//  LoggerTest
//
//  Created by Florent Pillet on 10/6/13.
//  Copyright (c) 2013 Florent Pillet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTMainViewController : UITableViewController

- (IBAction)booleanSettingDidChange:(id)sender;

@property (weak, nonatomic) IBOutlet UITableViewCell *logFrequencyCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *directHostCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *bonjourSettingsCell;
@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *booleanSettings;

@end
