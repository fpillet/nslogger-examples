//
//  LoggerTestTests.m
//  LoggerTestTests
//
//  Created by Florent Pillet on 10/5/13.
//  Copyright (c) 2013 Florent Pillet. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LoggerClient.h"

@interface LoggerTestTests : XCTestCase

@end

@implementation LoggerTestTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
	LoggerFlush(NULL, YES);
    [super tearDown];
}

- (void)testBasicLogging
{
	LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"test", 0, @"This is a test message");
}

@end
