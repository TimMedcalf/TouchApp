//
//  NewsItem.m
//  LeedsMetStudentUnion
//
//  Created by Tim Medcalf on 27/06/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "NewsItem.h"
#import "FeedItem.h"
//#import "HTMLParser.h"

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

@implementation NewsItem



#pragma mark lifecycle



#pragma mark overrides
- (void)procesSavedDictionary:(NSDictionary *)dict
{
  self.pubDate = dict[PubDateKey];
  self.link = dict[LinkKey];
  self.title = dict[TitleKey];
  self.description = dict[DescriptionKey];
}

- (void)processXMLDictionary:(NSDictionary *)dict andBaseURL:(NSURL *)baseURL
{
  //NSLog(@"News Dict: %@", dict);
  self.pubDate = dict[XML_PubDate];
  self.link = dict[XML_Link];
  self.title = dict[XML_Title];
  self.description = dict[XML_Description];
}

- (void)populateDictionary:(NSMutableDictionary *)dict
{
  if (self.pubDate) dict[PubDateKey] = self.pubDate;
  if (self.link) dict[LinkKey] = self.link;
  if (self.title) dict[TitleKey] = self.title;
  if (self.description) dict[DescriptionKey] = self.description;
}

- (NSString *)htmlForWebView
{
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
