//
//  LTDirectHostViewController.m
//  LoggerTest
//
//  Created by Florent Pillet on 10/6/13.
//  Copyright (c) 2013 Florent Pillet. All rights reserved.
//

#import "LTDirectHostViewController.h"

@implementation LTDirectHostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	self.hostField.text = [ud stringForKey:@"directHost"];
	self.portField.text = [NSString stringWithFormat:@"%@", [ud objectForKey:@"directPort"] ?: @0];
}

- (IBAction)hostDidChange:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setObject:[sender text] forKey:@"directHost"];
}

- (IBAction)portDidChange:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setObject:@([[sender text] integerValue]) forKey:@"directPort"];
}

@end
