//
//  LTRunLogsViewController.m
//  LoggerTest
//
//  Created by Florent Pillet on 10/6/13.
//  Copyright (c) 2013 Florent Pillet. All rights reserved.
//

#import "LTRunLogsViewController.h"
#import "LoggerClient.h"

#define NUM_LOGGING_QUEUES	2

static void logRandomImage(int numImage);

@interface LTRunLogsViewController ()
@property (strong, nonatomic) NSArray *tagsArray;
@property (strong, nonatomic) NSMutableArray *loggingQueues;
@property (nonatomic) dispatch_source_t timer;
@end

@implementation LTRunLogsViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	char label[32];
	self.loggingQueues = [[NSMutableArray alloc] initWithCapacity:NUM_LOGGING_QUEUES];
	for (int i=0; i < NUM_LOGGING_QUEUES; i++)
	{
		sprintf(label, "logging queue %d", i);
		[self.loggingQueues addObject:dispatch_queue_create(label, NULL)];
	}
	self.tagsArray = @[@"main",@"audio",@"video",@"network",@"database"];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self startLogging];
}

- (IBAction)stopLogging:(id)sender
{
	if (self.timer != NULL)
		dispatch_source_cancel(self.timer);
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)startLogging
{
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

	// Configure direct host
	NSString *host = [([ud stringForKey:@"directHost"] ?: @"") stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	UInt32 port = (UInt32)[([ud objectForKey:@"directPort"] ?: @0) unsignedIntegerValue];
	port = MAX(0, MIN(port, 65535));
	if ([host length] && port != 0)
		LoggerSetViewerHost(NULL, (__bridge CFStringRef) host, (UInt32) port);
	else
		LoggerSetViewerHost(NULL, NULL, 0);

	uint32_t options = kLoggerOption_UseSSL;
	if ([ud boolForKey:@"browseBonjour"])
		options |= kLoggerOption_BrowseBonjour;
	if ([ud boolForKey:@"browseOnlyLocalDomain"])
		options |= kLoggerOption_BrowseOnlyLocalDomain;
	if ([ud boolForKey:@"bufferLogs"])
		options |= kLoggerOption_BufferLogsUntilConnection;
	if  ([ud boolForKey:@"captureConsole"])
		options |= kLoggerOption_CaptureSystemConsole;

	LoggerSetOptions(NULL, options);

	// Start logging random messages
	uint64_t interval = ((uint64_t) [[ud objectForKey:@"logInterval"] integerValue] * 1000LL * 1000LL) * (uint64_t)NUM_LOGGING_QUEUES;
	counter = 0;
	imagesCounter = 0;
	self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
	dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW,0), interval, interval/2);
	dispatch_source_set_event_handler(self.timer, ^{
		for (NSUInteger q = 0; q < NUM_LOGGING_QUEUES; q++)
		{
			dispatch_async(self.loggingQueues[q], ^{
				int phase = arc4random() % 10;
				if (phase == 7)
				{
					NSLog(@"Some message %d to NSLog", counter++);
				}
				else if (phase == 6)
				{
					fprintf(stdout, "Some message %d to stdout\n", counter++);
					fflush(stdout);		// required for stdout to be flushed when not connected to Xcode debugger
				}
				else if (phase == 5)
				{
					fprintf(stderr, "Some message %d to stderr\n", counter++);
					fflush(stderr);
				}
				else if (phase != 1)
				{
					NSMutableString *s = [NSMutableString stringWithFormat:@"test log message %d - Random characters follow: ", counter++];
					int nadd = 1 + arc4random() % 150;
					for (int i = 0; i < nadd; i++)
						[s appendFormat:@"%c", 32 + (arc4random() % 27)];
					LogMessage([self.tagsArray objectAtIndex:(arc4random() % [self.tagsArray count])], arc4random() % 3, @"%@", s);
				}
				else if (phase == 1)
				{
					unsigned char *buf = (unsigned char *)malloc(1024);
					int n = 1 + arc4random() % 1024;
					for (int i = 0; i < n; i++)
						buf[i] = (unsigned char)arc4random();
					LogData(@"main", 1, [[NSData alloc] initWithBytesNoCopy:buf length:n]);
				}
				else if (phase == 5)
				{
					logRandomImage(++imagesCounter);
				}
				dispatch_async(dispatch_get_main_queue(), ^{
					self.messageCountLabel.text = [NSString stringWithFormat:@"%d", counter];
				});
			});
		}
	});
	dispatch_resume(self.timer);
}

@end

static void logRandomImage(int numImage)
{
	UIGraphicsBeginImageContext(CGSizeMake(100, 100));
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGFloat r = (CGFloat)(arc4random() % 256) / 255.0f;
	CGFloat g = (CGFloat)(arc4random() % 256) / 255.0f;
	CGFloat b = (CGFloat)(arc4random() % 256) / 255.0f;
	UIColor *fillColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
	CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
	CGContextFillRect(ctx, CGRectMake(0, 0, 100, 100));
	CGContextSetTextMatrix(ctx, CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, 100), CGAffineTransformMakeScale(1.0f, -1.0f)));
	CGContextSelectFont(ctx, "Helvetica", 14.0, kCGEncodingMacRoman);
	CGContextSetShadowWithColor(ctx, CGSizeMake(1, 1), 1.0f, [UIColor whiteColor].CGColor);
	CGContextSetTextDrawingMode(ctx, kCGTextFill);
	CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
	char buf[64];
	sprintf(buf, "Log Image %d", numImage);
	CGContextShowTextAtPoint(ctx, 0, 50, buf, strlen(buf));
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	CGSize sz = img.size;
	LogImageData(@"image", 0, (int)sz.width, (int)sz.height, UIImagePNGRepresentation(img));
	UIGraphicsEndImageContext();
}
