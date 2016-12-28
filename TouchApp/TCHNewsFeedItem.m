//
//  TCHNewsFeedItem.m
//  TouchApp
//
//  Created by Tim Medcalf on 27/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <KissXML/DDXMLElementAdditions.h>
#import "TCHNewsFeedItem.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
NSString *const kTCHNewsFeedItemKey_Title = @"title";
NSString *const kTCHNewsFeedItemKey_Link = @"link";
NSString *const kTCHNewsFeedItemKey_Text = @"content:encoded";
NSString *const kTCHNewsFeedItemKey_PubDate = @"pubDate";
#pragma clang diagnostic pop

@implementation TCHNewsFeedItem

#pragma mark overrides

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        _pubDate = dict[kTCHNewsFeedItemKey_PubDate];
        _link = dict[kTCHNewsFeedItemKey_Link];
        _title = dict[kTCHNewsFeedItemKey_Title];
        _text = dict[kTCHNewsFeedItemKey_Text];
    }
    return self;
}

- (instancetype)initWithXMLElement:(DDXMLElement *)element andBaseURL:(NSURL *)baseURL {
    
    self = [super initWithXMLElement:element andBaseURL:baseURL];
    if (self) {
        
        // TODO - these dateformatters shouldn't really be created for every item!
        
        //decode the string from text format 'Wed, 09 Nov 2016 19:32:01 +0000'
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        inputFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        inputFormatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
        NSString *dateStr = [element elementForName:kTCHNewsFeedItemKey_PubDate].stringValue;
        NSDate *tmpDate = [inputFormatter dateFromString:dateStr];
        
        //convert the date to be in string format "Posted on July 15, 2014"
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        outputFormatter.locale = inputFormatter.locale;
        outputFormatter.dateFormat = @"MMMM d, yyyy";
        _pubDate = [NSString stringWithFormat:@"Posted on %@",[outputFormatter stringFromDate:tmpDate]];
        
        _link = [element elementForName:kTCHNewsFeedItemKey_Link].stringValue;
        _title = [element elementForName:kTCHNewsFeedItemKey_Title].stringValue;
        _text = [element elementForName:kTCHNewsFeedItemKey_Text].stringValue;
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    if (self.pubDate) dict[kTCHNewsFeedItemKey_PubDate] = self.pubDate;
    if (self.link) dict[kTCHNewsFeedItemKey_Link] = self.link;
    if (self.title) dict[kTCHNewsFeedItemKey_Title] = self.title;
    if (self.text) dict[kTCHNewsFeedItemKey_Text] = self.text;
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (NSString *)htmlForWebView {
  //inject some CSS
  //note that strings can be run across multiple lines without having to reassign or append - just make sure quotes are at the start and end of each line
  return [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width\" />"
	"<link rel=\"stylesheet\" media=\"only screen and (max-device-width: 480px)\" href=\"mobile.css\" />"
	"<link rel=\"stylesheet\" media=\"only screen and (min-device-width: 481px) and (max-device-width: 768px)\" href=\"ipad.css\" />"
	"<link rel=\"stylesheet\" media=\"only screen and (min-device-width: 481px) and (orientation:landscape)\" href=\"ipad_landscape.css\" /></head>"
	"<body><div id='headerwrapper'><div id='headercell'><div id='title'><strong>%@</strong><br /><span id='pubdate'>%@</span></div></div></div>"
    "<div id=\"bodycopycontainer\"><p class='bodycopy'>%@</p></div></body></html>", self.title,self.pubDate,self.text];
}

@end
