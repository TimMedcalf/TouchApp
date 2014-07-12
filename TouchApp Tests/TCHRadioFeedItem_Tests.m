//
//  TCHRadioFeedItemTests.m
//  TouchApp
//
//  Created by Tim Medcalf on 12/07/2014.
//  Copyright (c) 2014 ErgoThis Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TCHRadioFeedItem.h"

@interface TCHRadioFeedItem_Tests : XCTestCase

@end

@implementation TCHRadioFeedItem_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/*
 RadioFeedItem summary field should replace \n\n with <p>
 */
- (void)testRadioFeedItemSummaryParagraphs {
  NSString *testString = @"This should have the paragraphs(\n\n) taken out of the string and replaced with HTML para marks.\n\n";
  XCTAssertFalse([testString rangeOfString:@"\n\n"].location == NSNotFound, @"Error setting up test.");
  TCHRadioFeedItem *radioFeedItem = [[TCHRadioFeedItem alloc] initWithDictionary:@{Key_Radio_Summary:testString}];
  XCTAssertTrue([radioFeedItem.summary rangeOfString:@"\n\n"].location == NSNotFound, @"Summary field still contains multiple line breaks in the test string.");
  XCTAssertFalse([radioFeedItem.summary rangeOfString:@"<p>"].location == NSNotFound, @"Did not replace paragraphs with html in the test string.");
}

/*
 RadioFeedItem should trim whitespace and newlines from the link passed to it
 */
- (void)testRadioFeedItemLinkWhitespace {
  NSString *testString = @"   http://www.google.co.uk    \n";
  NSString *trimmedTestString = [testString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  XCTAssertFalse([testString isEqualToString:trimmedTestString], @"Error setting up test.");
  TCHRadioFeedItem *radioFeedItem = [[TCHRadioFeedItem alloc] initWithDictionary:@{Key_Radio_Link:testString}];
  XCTAssertFalse([radioFeedItem.link isEqualToString:testString], @"Link property still contains whitespace");
}

/*
 RadioFeedItem should divert all links to iPhone specific radio streams
 */
- (void)testRadioFeedItemDivertsToiPhoneRadioStreams
{
  //define a non iphone link
  NSString *testLink = @"http://www.touchshop.org/touchradio/Radio100.mp3";
  //check that our tests will work on this link
  XCTAssertTrue([testLink rangeOfString:@"touchradio"].location != NSNotFound, @"Error setting up test.");
  //now create the object that should automatically deal with it
  TCHRadioFeedItem *rf = [[TCHRadioFeedItem alloc] initWithDictionary:@{Key_Radio_Link:testLink}];
  XCTAssertTrue([rf.link rangeOfString:@"touchradio"].location == NSNotFound, @"touchRadio still in the link text: \"%@\"", rf.link);
  XCTAssertTrue([rf.link rangeOfString:@"touchiphoneradio"].location != NSNotFound, @"touchiphoneradio could not be found in the link text: \"%@\"", rf.link);
}
 


@end
