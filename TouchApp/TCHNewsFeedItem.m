//
//  TCHNewsFeedItem.m
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 27/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHNewsFeedItem.h"
#import "TouchXML.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
NSString *const kTCHNewsFeedItemKey_Title = @"title";
NSString *const kTCHNewsFeedItemKey_Link = @"link";
NSString *const kTCHNewsFeedItemKey_Description = @"description";
NSString *const kTCHNewsFeedItemKey_PubDate = @"pubDate";
#pragma clang diagnostic pop

@implementation TCHNewsFeedItem

#pragma mark overrides

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        self.pubDate = dict[kTCHNewsFeedItemKey_PubDate];
        self.link = dict[kTCHNewsFeedItemKey_Link];
        self.title = dict[kTCHNewsFeedItemKey_Title];
        self.description = dict[kTCHNewsFeedItemKey_Description];
    }
    return self;
}

- (instancetype)initWithXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL {
    self = [super initWithXMLElement:element andBaseURL:baseURL];
    if (self) {
        self.pubDate = [[element nodeForXPath:kTCHNewsFeedItemKey_PubDate error:nil] stringValue];
        self.link = [[element nodeForXPath:kTCHNewsFeedItemKey_Link error:nil] stringValue];
        self.title = [[element nodeForXPath:kTCHNewsFeedItemKey_Title error:nil] stringValue];
        self.description = [[element nodeForXPath:kTCHNewsFeedItemKey_Description error:nil] stringValue];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    if (self.pubDate) dict[kTCHNewsFeedItemKey_PubDate] = self.pubDate;
    if (self.link) dict[kTCHNewsFeedItemKey_Link] = self.link;
    if (self.title) dict[kTCHNewsFeedItemKey_Title] = self.title;
    if (self.description) dict[kTCHNewsFeedItemKey_Description] = self.description;
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
    "<div id=\"bodycopycontainer\"><p class='bodycopy'>%@</p></div></body></html>", self.title,self.pubDate,self.description];
}

@end
