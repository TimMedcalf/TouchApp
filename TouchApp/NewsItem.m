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

@synthesize pubDate = _pubDate;
@synthesize link = _link;
@synthesize title = _title;
@synthesize description = _description;


#pragma mark lifecycle

- (void)dealloc
{
  [_pubDate release];
  [_link release];
  [_title release];
  [_description release];
  [super dealloc];
}


#pragma mark overrides
- (void)procesSavedDictionary:(NSDictionary *)dict
{
  self.pubDate = [dict objectForKey:PubDateKey];
  self.link = [dict objectForKey:LinkKey];
  self.title = [dict objectForKey:TitleKey];
  self.description = [dict objectForKey:DescriptionKey];
}

- (void)processXMLDictionary:(NSDictionary *)dict
{  
  self.pubDate = [dict objectForKey:XML_PubDate];
  self.link = [dict objectForKey:XML_Link];
  self.title = [dict objectForKey:XML_Title];
  self.description = [dict objectForKey:XML_Description];
}

- (void)populateDictionary:(NSMutableDictionary *)dict
{
  [dict setObject:self.pubDate forKey:PubDateKey];
  [dict setObject:self.link forKey:LinkKey];
  [dict setObject:self.title forKey:TitleKey];
  [dict setObject:self.description forKey:DescriptionKey];
}
- (BOOL)isEqualToItem:(NewsItem *)otherFeedItem
{
  return (([self.pubDate isEqualToString:otherFeedItem.pubDate]) &&
          ([self.title isEqualToString:otherFeedItem.title]) &&
          ([self.description isEqualToString:otherFeedItem.description]) &&
          ([self.imageLink isEqualToString:otherFeedItem.imageLink]));
}

- (NSString *) htmlForWebView
{
  //inject some CSS
  //note that strings can be run across multiple lines without having to reassign or append - just make sure quotes are at the start and end of each line
  return [NSString stringWithFormat:@"<meta name=\"viewport\" content=\"width=device-width\" />"
	"<link rel=\"stylesheet\" media=\"only screen and (max-device-width: 480px)\" href=\"mobile.css\" />"
	"<link rel=\"stylesheet\" media=\"only screen and (min-device-width: 481px) and (max-device-width: 1024px)\" href=\"ipad.css\" />"
	"<p id='title'><strong>%@</strong><br /></p>"
	"<span class='bodycopy'>%@</span>", self.title,self.description];
}
@end
