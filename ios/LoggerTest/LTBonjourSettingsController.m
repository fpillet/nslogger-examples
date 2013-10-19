//
//  LTBonjourSettingsController.m
//  LoggerTest
//
//  Created by Florent Pillet on 10/6/13.
//  Copyright (c) 2013 Florent Pillet. All rights reserved.
//

#import "LTBonjourSettingsController.h"

@implementation LTBonjourSettingsController

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	self.bonjourServiceName.text = [ud stringForKey:@"bonjourServiceName"];
	self.useBonjour.on = [ud boolForKey:@"browseBonjour"];
	self.localDomainOnly.on = [ud boolForKey:@"browseLocalDomainOnly"];
}


- (IBAction)bonjourServiceNameChanged:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setObject:[sender text] forKey:@"bonjourServiceName"];
}

- (IBAction)booleanChanged:(UISwitch *)sender
{
	[[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:[sender restorationIdentifier]];
}

@end
