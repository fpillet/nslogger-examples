//
//  LTRunLogsViewController.h
//  LoggerTest
//
//  Created by Florent Pillet on 10/6/13.
//  Copyright (c) 2013 Florent Pillet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTRunLogsViewController : UIViewController
{
	int counter;
	volatile int imagesCounter;
}

@property (weak, nonatomic) IBOutlet UILabel *messageCountLabel;
@property (weak, nonatomic) IBOutlet UIView *screenshotView;

- (IBAction)stopLogging:(id)sender;

@end
