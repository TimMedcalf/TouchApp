//
//  RadioItem.m
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

NSString *const Key_Radio_Author = @"itunes:author";
NSString *const Key_Radio_Title = @"title";
NSString *const Key_Radio_Summary = @"itunes:summary";
NSString *const Key_Radio_SubTitle = @"itunes:subtitle";
NSString *const Key_Radio_PubDate = @"pubDate";
NSString *const Key_Radio_Link = @"guid";
NSString *const Key_Radio_Duration = @"itunes:duration";
NSString *const Key_Radio_TitleLabel = @"itunes:subtitle"; 

NSString *const Key_ImageOverride = @"imageURL";


#import "RadioItem.h"

@implementation RadioItem

@synthesize author = _author;
@synthesize title = _title;
@synthesize titleLabel = _titleLabel;
@synthesize summary = _summary;
@synthesize subtitle = _subtitle;
@synthesize pubDate = _pubDate;
@synthesize link =_link;
@synthesize episode_duration = _episode_duration;


- (void)dealloc
{
  [_author release];
  [_title release];
  [_titleLabel release];
  [_summary release];
  [_subtitle release];
  [_pubDate release];
  [_link release];
  [_episode_duration release];
  [super dealloc];
}

#pragma mark overrides from FeedItem
- (void)procesSavedDictionary:(NSDictionary *)dict
{
  self.title = [dict objectForKey:Key_Radio_Title];
  self.titleLabel = [dict objectForKey:Key_Radio_TitleLabel];
  self.author = [dict objectForKey:Key_Radio_Author];
  self.summary = [dict objectForKey:Key_Radio_Summary];
  self.subtitle = [dict objectForKey:Key_Radio_SubTitle];
  self.pubDate = [dict objectForKey:Key_Radio_PubDate];
  self.link = [dict objectForKey:Key_Radio_Link];
  self.episode_duration = [dict objectForKey:Key_Radio_Duration];
}

- (void)processXMLDictionary:(NSDictionary *)dict andBaseURL:(NSURL *)baseURL
{ 
  self.title = [dict objectForKey:Key_Radio_Title];
  self.titleLabel = [dict objectForKey:Key_Radio_TitleLabel];
  self.author = [dict objectForKey:Key_Radio_Author];
  
  self.summary = [[dict objectForKey:Key_Radio_Summary]
                  stringByReplacingOccurrencesOfString:@"\n\n" withString:@"</p><p>"];  
    
  self.subtitle = [dict objectForKey:Key_Radio_SubTitle];
  NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
  [inputFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
  [inputFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
  NSString *dateStr = [dict objectForKey:Key_Radio_PubDate];
  self.pubDate = [inputFormatter dateFromString:dateStr];
  [inputFormatter release];
  self.link = [[dict objectForKey:Key_Radio_Link] 
               stringByReplacingOccurrencesOfString:@"touchradio" 
               withString:@"touchiphoneradio"];
  self.episode_duration = [dict objectForKey:Key_Radio_Duration];
    
 
  NSURL * tmpURL;
  
  //first check if there is an image override location
  if ([dict objectForKey:Key_ImageOverride])
  {
    NSString *tmpStr = [dict objectForKey:Key_ImageOverride];
    if ([tmpStr length] > 0)
    {
      tmpURL = [[NSURL alloc] initWithString:tmpStr];
      self.imageURL = tmpURL;
      [tmpURL release];
    }
  }
   
  //if not, generate an image url as per normal...
  if (!self.imageURL)
  {
    tmpURL = [[NSURL alloc] initWithString:[[[dict objectForKey:Key_Radio_Link] 
                                             stringByReplacingOccurrencesOfString:@".mp3" 
                                             withString:@".jpg"] 
                                            stringByReplacingOccurrencesOfString:@"touchradio/" 
                                            withString:@"touchradio/images/"]
                             relativeToURL:baseURL];
  
    self.imageURL = tmpURL;
    NSLog(@"Radio URL = %@", self.imageURL);
    [tmpURL release];
  }
  //NSLog(@"%@ - %@ - %@", self.catalogueNumber, self.artist, self.title);
}

- (void)populateDictionary:(NSMutableDictionary *)dict
{
  if (self.title) [dict setObject:self.title forKey:Key_Radio_Title];
  if (self.titleLabel) [dict setObject:self.titleLabel forKey:Key_Radio_TitleLabel];
  if (self.author) [dict setObject:self.author forKey:Key_Radio_Author];
  if (self.summary) [dict setObject:self.summary forKey:Key_Radio_Summary];
  if (self.subtitle) [dict setObject:self.subtitle forKey:Key_Radio_SubTitle];
  if (self.pubDate) [dict setObject:self.pubDate forKey:Key_Radio_PubDate];
  if (self.link) [dict setObject:self.link forKey:Key_Radio_Link];
  if (self.episode_duration) [dict setObject:self.episode_duration forKey:Key_Radio_Duration];    
}

- (NSComparisonResult)compare:(RadioItem *)item
{
  //compare in reverse so that we get the newest at the top.
  return [item.pubDate compare:self.pubDate];
}

- (NSString *)htmlForWebView
{
  //inject some CSS
  //note that strings can be run across multiple lines without having to reassign or append - just make sure quotes are at the start and end of each line
  return [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width\" />"
          "<link rel=\"stylesheet\" media=\"only screen and (max-device-width: 480px)\" href=\"mobile.css\" />"
          "<link rel=\"stylesheet\" media=\"only screen and (min-device-width: 481px) and (max-device-width: 1024px)\" href=\"ipad.css\" />"
          "<script type=\"text/javascript\" src=\"jquery-1.6.4.min.js\"></script></head>"
          "<script type=\"text/javascript\" src=\"audiocontrol.js\"></script>"
          "<body><div id='headerwrapper'><div id='headercell'><div id='title'><strong>%@</strong><br /><span id='byline'>%@</span></div></div></div>"
          "<p class='bodycopy'><p><img src='%@' /></p><p>%@</p>"
          "<div id='playerwrapper'><div><strong>Play</strong><br /><span class='subtitle'>Tap here to stream audio</span></div></div></p></body></html>", 
          self.titleLabel,self.title,self.imageURL,self.summary];
}






@end
