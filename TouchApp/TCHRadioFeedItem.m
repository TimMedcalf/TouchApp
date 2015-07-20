//
//  TCHRadioFeedItem.m
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
NSString *const Key_Radio_Author = @"itunes:author";
NSString *const Key_Radio_Title = @"title";
NSString *const Key_Radio_Summary = @"itunes:summary";
NSString *const Key_Radio_SubTitle = @"itunes:subtitle";
NSString *const Key_Radio_PubDate = @"pubDate";
NSString *const Key_Radio_Link = @"guid";
NSString *const Key_Radio_Duration = @"itunes:duration";
NSString *const Key_Radio_TitleLabel = @"itunes:subtitle";
NSString *const Key_ImageOverride = @"imageURL";
#pragma clang diagnostic pop


#import "TCHRadioFeedItem.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"

@implementation TCHRadioFeedItem

#pragma mark - setter overrides
- (void)setSummary:(NSString *)summary {
  //replace paragraphs with the HTML equivalent
  _summary = [summary stringByReplacingOccurrencesOfString:@"\n\n" withString:@"</p><p>"];
}

- (void)setLink:(NSString *)link {
  //trim whitespace and newlines
  _link = [link stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  _link = [_link stringByReplacingOccurrencesOfString:@"touchradio" withString:@"touchiphoneradio"];
}

#pragma mark overrides from FeedItem
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        _title = dict[Key_Radio_Title];
        _titleLabel = dict[Key_Radio_TitleLabel];
        _author = dict[Key_Radio_Author];
        _summary = dict[Key_Radio_Summary];
        _subtitle = dict[Key_Radio_SubTitle];
        _pubDate = dict[Key_Radio_PubDate];
        _link = dict[Key_Radio_Link];
        _episode_duration = dict[Key_Radio_Duration];;
    }
    return self;
}

- (instancetype)initWithXMLElement:(DDXMLElement *)element andBaseURL:(NSURL *)baseURL {
    self = [super initWithXMLElement:element andBaseURL:baseURL];
    if (self) {
        _title = [[element elementForName:Key_Radio_Title] stringValue];
        _titleLabel = [[element elementForName:Key_Radio_TitleLabel] stringValue];
        _author = [[element elementForName:Key_Radio_Author] stringValue];
        _summary = [[element elementForName:Key_Radio_Summary] stringValue];
        _subtitle = [[element elementForName:Key_Radio_SubTitle] stringValue];

        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        inputFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        inputFormatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
        NSString *dateStr = [[element elementForName:Key_Radio_PubDate] stringValue];
        _pubDate = [inputFormatter dateFromString:dateStr];

        _link = [[element elementForName:Key_Radio_Link] stringValue];
        _episode_duration = [[element elementForName:Key_Radio_Duration] stringValue];

        self.imageURL = nil;
        NSString *imageOverride = [[element elementForName:Key_ImageOverride] stringValue];
        //first check if there is an image override location
        if (imageOverride && (imageOverride.length > 0)) {
            self.imageURL = [[NSURL alloc] initWithString:imageOverride];
        }
        //if not, generate an image url as per normal...
        if (!self.imageURL) {
            NSString *urlString = [[element elementForName:Key_Radio_Link] stringValue];
            urlString = [urlString stringByReplacingOccurrencesOfString:@".mp3" withString:@".jpg"];
            urlString = [urlString stringByReplacingOccurrencesOfString:@"touchradio/" withString:@"touchradio/images/"];

            self.imageURL = [[NSURL alloc] initWithString:urlString relativeToURL:baseURL];
            DDLogDebug(@"Radio URL = %@", self.imageURL);
        }
        DDLogDebug(@"%@ - %@ - %@", self.author, self.title, self.titleLabel);
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    if (self.title) dict[Key_Radio_Title] = self.title;
    if (self.titleLabel) dict[Key_Radio_TitleLabel] = self.titleLabel;
    if (self.author) dict[Key_Radio_Author] = self.author;
    if (self.summary) dict[Key_Radio_Summary] = self.summary;
    if (self.subtitle) dict[Key_Radio_SubTitle] = self.subtitle;
    if (self.pubDate) dict[Key_Radio_PubDate] = self.pubDate;
    if (self.link) dict[Key_Radio_Link] = self.link;
    if (self.episode_duration) dict[Key_Radio_Duration] = self.episode_duration;
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (NSComparisonResult)compare:(TCHBaseFeedItem *)item {
  //compare in reverse so that we get the newest at the top.

  return [((TCHRadioFeedItem *)item).pubDate compare:self.pubDate];
}

- (NSString *)htmlForWebView {
  NSString *playerLink = @"";
  if ((self.link).length > 0) {
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
