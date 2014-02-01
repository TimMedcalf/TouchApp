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

#pragma mark overrides from FeedItem
- (void)procesSavedDictionary:(NSDictionary *)dict {
  self.title = dict[Key_Radio_Title];
  self.titleLabel = dict[Key_Radio_TitleLabel];
  self.author = dict[Key_Radio_Author];
  self.summary = dict[Key_Radio_Summary];
  self.subtitle = dict[Key_Radio_SubTitle];
  self.pubDate = dict[Key_Radio_PubDate];
  self.link = dict[Key_Radio_Link];
  self.episode_duration = dict[Key_Radio_Duration];
}

- (void)processXMLDictionary:(NSDictionary *)dict andBaseURL:(NSURL *)baseURL {
  self.title = dict[Key_Radio_Title];
  self.titleLabel = dict[Key_Radio_TitleLabel];
  self.author = dict[Key_Radio_Author];
  
  self.summary = [dict[Key_Radio_Summary]
                  stringByReplacingOccurrencesOfString:@"\n\n" withString:@"</p><p>"];  
    
  self.subtitle = dict[Key_Radio_SubTitle];
  NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
  [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
  [inputFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
  NSString *dateStr = dict[Key_Radio_PubDate];
  self.pubDate = [inputFormatter dateFromString:dateStr];
  self.link = [[dict[Key_Radio_Link] 
               stringByReplacingOccurrencesOfString:@"touchradio" 
                withString:@"touchiphoneradio"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  self.episode_duration = dict[Key_Radio_Duration];
    
 
  NSURL *tmpURL;
  
  //first check if there is an image override location
  if (dict[Key_ImageOverride]) {
    NSString *tmpStr = dict[Key_ImageOverride];
    if ([tmpStr length] > 0) {
      tmpURL = [[NSURL alloc] initWithString:tmpStr];
      self.imageURL = tmpURL;
    }
  }
   
  //if not, generate an image url as per normal...
  if (!self.imageURL) {
    tmpURL = [[NSURL alloc] initWithString:[[dict[Key_Radio_Link] 
                                             stringByReplacingOccurrencesOfString:@".mp3" 
                                             withString:@".jpg"]
                                            stringByReplacingOccurrencesOfString:@"touchradio/" 
                                            withString:@"touchradio/images/"]
                             relativeToURL:baseURL];
    self.imageURL = tmpURL;
    //NSLog(@"Radio URL = %@", self.imageURL);
  }
  //NSLog(@"%@ - %@ - %@", self.catalogueNumber, self.artist, self.title);
}

- (void)populateDictionary:(NSMutableDictionary *)dict {
  if (self.title) dict[Key_Radio_Title] = self.title;
  if (self.titleLabel) dict[Key_Radio_TitleLabel] = self.titleLabel;
  if (self.author) dict[Key_Radio_Author] = self.author;
  if (self.summary) dict[Key_Radio_Summary] = self.summary;
  if (self.subtitle) dict[Key_Radio_SubTitle] = self.subtitle;
  if (self.pubDate) dict[Key_Radio_PubDate] = self.pubDate;
  if (self.link) dict[Key_Radio_Link] = self.link;
  if (self.episode_duration) dict[Key_Radio_Duration] = self.episode_duration;    
}

- (NSComparisonResult)compare:(FeedItem *)item {
  //compare in reverse so that we get the newest at the top.

  return [((RadioItem *)item).pubDate compare:self.pubDate];
}

- (NSString *)htmlForWebView {
  NSString *playerLink = @"";
  if ([self.link length] > 0) {
    playerLink = @"<div id='playerwrapper'><div><strong>Play</strong><br /><span class='subtitle'>Tap here to stream audio</span></div></div>";
  }
  //inject some CSS
  //note that strings can be run across multiple lines without having to reassign or append - just make sure quotes are at the start and end of each line
  return [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width\" />"
          "<link rel=\"stylesheet\" media=\"only screen and (max-device-width: 480px)\" href=\"mobile.css\" />"
          "<link rel=\"stylesheet\" media=\"only screen and (min-device-width: 481px) and (max-device-width: 768px)\" href=\"ipad.css\" />"
          "<link rel=\"stylesheet\" media=\"only screen and (min-device-width: 481px) and (orientation:landscape)\" href=\"ipad_landscape.css\" />"
          "<script type=\"text/javascript\" src=\"jquery-1.6.4.min.js\"></script>"
          "<script type=\"text/javascript\" src=\"audiocontrol.js\"></script></head>"
          "<body><div id='headerwrapper'><div id='headercell'><div id='title'><strong>%@</strong><br /><span id='byline'>%@</span></div></div></div>"
          "<div id=\"bodycopycontainer\"><p class='bodycopy'><p><img src='%@' /></p><p>%@</p></p></div>"
          "<div id=\"buttoncontainer\">"
          "%@"
          "</div>"
          "</body></html>", self.titleLabel, self.title, self.imageURL, self.summary, playerLink];
}

@end
