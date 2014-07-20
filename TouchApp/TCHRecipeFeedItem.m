//
//  TCHRecipeFeedItem.m
//  TouchApp
//
//  Created by Tim Medcalf on 26/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import <KissXML/DDXMLElementAdditions.h>
#import "TCHRecipeFeedItem.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
NSString *const Key_Recipe_Title = @"title";
NSString *const Key_Recipe_Excerpt = @"excerpt";
NSString *const Key_Recipe_Description = @"description";
NSString *const Key_Recipe_PubDate = @"pubDate";
#pragma clang diagnostic pop


@implementation TCHRecipeFeedItem

#pragma mark overrides from FeedItem
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        self.recipeTitle = dict[Key_Recipe_Title];
        self.recipeExcerpt = dict[Key_Recipe_Excerpt];
        self.recipeDescription = dict[Key_Recipe_Description];
        self.recipePubDate = dict[Key_Recipe_PubDate];
    }
    return self;
}


- (instancetype)initWithXMLElement:(DDXMLElement *)element andBaseURL:(NSURL *)baseURL {
    self = [super initWithXMLElement:element andBaseURL:baseURL];
    if (self) {
        self.recipeTitle = [[element elementForName:Key_Recipe_Title] stringValue];
        self.recipeExcerpt = [[element elementForName:Key_Recipe_Excerpt] stringValue];
        self.recipeDescription = [[element elementForName:Key_Recipe_Description] stringValue];
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [inputFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
        NSString *dateStr = [[element elementForName:Key_Recipe_PubDate] stringValue];
        self.recipePubDate = [inputFormatter dateFromString:dateStr];
    }
    return self;
}


- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    if (self.recipeTitle) dict[Key_Recipe_Title] = self.recipeTitle;
    if (self.recipeExcerpt) dict[Key_Recipe_Excerpt] = self.recipeExcerpt;
    if (self.recipeDescription) dict[Key_Recipe_Description] = self.recipeDescription;
    if (self.recipePubDate) dict[Key_Recipe_PubDate] = self.recipePubDate;
    return [NSDictionary dictionaryWithDictionary:dict];
}


- (NSComparisonResult)compare:(TCHBaseFeedItem *)item {
  //compare in reverse so that we get the newest at the top.
  return [((TCHRecipeFeedItem *)item).recipePubDate compare:self.recipePubDate];
}

- (NSString *)htmlForWebView {
  //inject some CSS
  //note that strings can be run across multiple lines without having to reassign or append - just make sure quotes are at the start and end of each line
  return [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width\" />"
          "<link rel=\"stylesheet\" media=\"only screen and (max-device-width: 480px)\" href=\"mobile.css\" />"
          "<link rel=\"stylesheet\" media=\"only screen and (min-device-width: 481px) and (max-device-width: 768px)\" href=\"ipad.css\" />"
          "<link rel=\"stylesheet\" media=\"only screen and (min-device-width: 481px) and (orientation:landscape)\" href=\"ipad_landscape.css\" /></head>"
          "<body><div id='headerwrapper'><div id='headercell'><div id='title'><strong>%@</strong><br /><span id='byline'>by %@</span></div></div></div>"
          "<div id=\"bodycopycontainer\"><p class='bodycopy'>%@</p></div></body></html>", self.recipeExcerpt,self.recipeTitle,self.recipeDescription];
}

@end
