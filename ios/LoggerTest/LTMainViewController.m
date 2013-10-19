//
//  LTMainViewController.m
//  LoggerTest
//
//  Created by Florent Pillet on 10/6/13.
//  Copyright (c) 2013 Florent Pillet. All rights reserved.
//

#import "LTMainViewController.h"
#import "LTRunLogsViewController.h"

@interface LTMainViewController ()

@end

@implementation LTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	for (UISwitch *sw in self.booleanSettings)
		sw.on = [ud boolForKey:sw.restorationIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self updateLogIntervalLabel];
	[self updateDirectHostLabel];
	[self updateBonjourDetailsLabel];
}

- (IBAction)booleanSettingDidChange:(id)sender
{
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	[ud setBool:((UISwitch *)sender).on forKey:[sender restorationIdentifier]];
	[ud synchronize];
}

- (void)updateLogIntervalLabel
{
	NSNumber *logInterval = [[NSUserDefaults standardUserDefaults] objectForKey:@"logInterval"] ?: @0;
	NSDictionary *freqs = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LogFrequencies"
																										 ofType:@"plist"]];
	for (NSString *key in freqs)
	{
		if ([freqs[key] isEqual:logInterval])
		{
			self.logFrequencyCell.detailTextLabel.text = key;
			break;
		}
	}
	[self.tableView reloadData];
}

- (void)updateDirectHostLabel
{
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	NSString *host = [ud objectForKey:@"directHost"] ?: @"";
	NSInteger port = [[ud objectForKey:@"directPort"] integerValue];
	NSString *text;
	if (![host length] && port == 0)
		text = NSLocalizedString(@"Not defined", @"");
	else if (![host length] || port  == 0)
		text = NSLocalizedString(@"Incomplete", @"");
	else
		text = [NSString stringWithFormat:@"%@:%d", host, port];
	self.directHostCell.detailTextLabel.text = text;
}

- (void)updateBonjourDetailsLabel
{
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	BOOL browseBonjour = [ud boolForKey:@"browseBonjour"];
	BOOL localDomainOnly = [ud boolForKey:@"browseLocalDomainOnly"];
	NSString *bonjourServiceName = [ud stringForKey:@"bonjourServiceName"] ?: @"";
	NSString *text;
	if (!browseBonjour)
		text = NSLocalizedString(@"Bonjour browsing disabled", @"");
	else if ([bonjourServiceName length])
	{
		if (localDomainOnly)
			text = [NSString stringWithFormat:NSLocalizedString(@"Enabled, connect to '%@' only (local domain).", @""), bonjourServiceName];
		else
			text = [NSString stringWithFormat:NSLocalizedString(@"Enabled, connect to '%@' only.", @""), bonjourServiceName];
	}
	else if (localDomainOnly)
		text = NSLocalizedString(@"Enabled, browse local domain only.", @"");
	else
		text = NSLocalizedString(@"Enabled, browse all domains.", @"");
	self.bonjourSettingsCell.detailTextLabel.text = text;
}

- (IBAction)startRunningLogs:(id)sender
{
	LTRunLogsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RunLogs"];
	[self addChildViewController:vc];
	
}

@end
