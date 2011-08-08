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

//- (NSString *) stripTags:(NSString *)str
//{
//  NSMutableString *html = [NSMutableString stringWithCapacity:[str length]];
//  
//  NSScanner *scanner = [NSScanner scannerWithString:str];
//  NSString *tempText = nil;
//  
//  while (![scanner isAtEnd])
//  {
//    [scanner scanUpToString:@"<" intoString:&tempText];
//    
//    if (tempText != nil)
//      [html appendString:tempText];
//    
//    [scanner scanUpToString:@">" intoString:NULL];
//    
//    if (![scanner isAtEnd])
//      [scanner setScanLocation:[scanner scanLocation] + 1];
//    
//    tempText = nil;
//  }
//  
//  return html;
//}

//- (void)walkNodeTree:(HTMLNode *)node;
//{
//  //if (([node nodetype] != HTMLHrefNode))
//  {
//    NSLog(@"Node Type - %i",[node nodetype]);
//    if ([node nodetype] == HTMLTextNode)
//      NSLog(@"%@",[node rawContents]);
//    else
//      NSLog(@"%@",[node contents]);
//    NSString *contents = [node contents];
//    if (contents)
//      self.description = [self.description stringByAppendingString:contents];
//  }
//  for (HTMLNode *child in [node children])
//    [self walkNodeTree:child];
//}


- (void)dealloc
{
  //NSLog(@"[%@ %@] %@", [self class], NSStringFromSelector(_cmd),self.pubDate);
  //NSLog(@"item dealloc");
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
// the feed just has text pubDates so let's not worry about converting them
//  NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
//  [inputFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
//  [inputFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
//  NSString *dateStr = [dict objectForKey:XML_PubDate];
//  self.pubDate = [inputFormatter dateFromString:dateStr];
//  [inputFormatter release];inputFormatter = nil;
  
  //link and title are just taken as is...
  self.pubDate = [dict objectForKey:XML_PubDate];
  self.link = [dict objectForKey:XML_Link];
  self.title = [dict objectForKey:XML_Title];
  self.description = [dict objectForKey:XML_Description];
  //but decription needs a bit of work!
  /*
  NSError *error = nil;
  HTMLParser *html = [[HTMLParser alloc] initWithString:[dict objectForKey:XML_Description] error:&error];
  if (error)
  {
    NSLog(@"Error - %@",error);
  }
  else
  {
    //NSLog(@"Getting image");
    HTMLNode *body = [html body];
    HTMLNode *image = [body findChildOfClass:@"imagefield imagefield-field_article_image"];
    if (image)
    {
      NSString *link = [image getAttributeNamed:@"src"];
      self.imageLink = [[link componentsSeparatedByString:@"?"] objectAtIndex:0];
    }
    //clear font tags
    self.description = [[body rawContents] stringByReplacingOccurrencesOfString:@"<font" withString:@"<LMSU"];
    //clear placeholder image
    NSString *placeholder = @"<img class=\"imagefield imagefield-field_article_image\" width=\"100\" height=\"75\" alt=\"\" src=\"http://www.leedsmetsu.co.uk/files/imagefield_default_images/lmsu_logo_light_0.gif?1281087932\">";
    self.description = [self.description stringByReplacingOccurrencesOfString:placeholder withString:@""];
  }
  [html release]; html = nil;
   */
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

- (NSComparisonResult)compare:(NewsItem *)item
{
  //return [item.pubDate compare:self.pubDate];
  return NSOrderedSame;
}

- (NSString *) htmlForWebView
{
  //strings can be run across multiple lines without having to reassign or append
  return [NSString stringWithFormat:@"<meta name=\"viewport\" content=\"width=device-width\" />"
	"<link rel=\"stylesheet\" media=\"only screen and (max-device-width: 480px)\" href=\"http://www.daveknapik.com/dropbox/mobile.css\" />"
	"<link rel=\"stylesheet\" media=\"only screen and (min-device-width: 481px) and (max-device-width: 1024px)\" href=\"http://www.daveknapik.com/dropbox/ipad.css\" />"
	"<p id='title'><strong>%@</strong><br /></p>"
	"<span class='bodycopy'>%@</span>", self.title,self.description];
}
@end
