//
//  TCHNewsFeedItem.m
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 27/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHNewsFeedItem.h"

//keys we use in our own dictionary (saving and loading)
NSString *const PubDateKey = @"pubDate";
NSString *const LinkKey = @"link";
NSString *const TitleKey = @"title";
NSString *const DescriptionKey = @"description";

//keys when we're parsing an xml node
NSString *const XML_Title = @"title";
NSString *const XML_Link = @"link";
NSString *const XML_Description = @"description";
NSString *const XML_PubDate = @"pubDate";


@implementation TCHNewsFeedItem

#pragma mark overrides

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        self.pubDate = dict[PubDateKey];
        self.link = dict[LinkKey];
        self.title = dict[TitleKey];
        self.description = dict[DescriptionKey];
    }
    return self;
}

- (instancetype)initWithXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL {
    self = [super initWithXMLElement:element andBaseURL:baseURL];
    if (self) {
        self.pubDate = [[element nodeForXPath:XML_PubDate error:nil] stringValue];
        self.link = [[element nodeForXPath:XML_Link error:nil] stringValue];
        self.title = [[element nodeForXPath:XML_Title error:nil] stringValue];
        self.description = [[element nodeForXPath:XML_Description error:nil] stringValue];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    if (self.pubDate) dict[PubDateKey] = self.pubDate;
    if (self.link) dict[LinkKey] = self.link;
    if (self.title) dict[TitleKey] = self.title;
    if (self.description) dict[DescriptionKey] = self.description;
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
