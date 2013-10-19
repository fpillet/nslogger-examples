//
//  LTLogFrequencyViewController.m
//  LoggerTest
//
//  Created by Florent Pillet on 10/6/13.
//  Copyright (c) 2013 Florent Pillet. All rights reserved.
//

#import "LTLogFrequencyViewController.h"

@interface LTLogFrequencyViewController ()
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *values;
@end

@implementation LTLogFrequencyViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LogFrequencies"
																									 ofType:@"plist"]];
	NSMutableArray *t = [NSMutableArray arrayWithArray:[d allKeys]]; // just a placeholder
	self.values = [[d allValues] sortedArrayUsingSelector:@selector(compare:)];
	[d enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		t[[self.values indexOfObject:obj]] = key;
	}];
	self.titles = t;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FrequencyCell" forIndexPath:indexPath];
	NSNumber *logInterval = [[NSUserDefaults standardUserDefaults] objectForKey:@"logInterval"];
	cell.accessoryType = ([self.values indexOfObject:logInterval] == indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	cell.textLabel.text = self.titles[(NSUInteger)indexPath.row];
	cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ ms interval", @"log interval detail"), self.values[(NSUInteger) indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row >= 0)
	{
		NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
		NSInteger currentIdx = [self.values indexOfObject:[ud objectForKey:@"logInterval"] ?: @0];
		if (currentIdx != indexPath.row)
		{
			[ud setObject:self.values[(NSUInteger)indexPath.row] forKey:@"logInterval"];
			[ud synchronize];
			[self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows]
								  withRowAnimation:UITableViewRowAnimationFade];
		}
	}
}

@end
