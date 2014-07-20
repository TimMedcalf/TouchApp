//
//  TCHRecipeFeedItem.m
//  TouchApp
//
//  Created by Tim Medcalf on 26/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHRecipeFeedItem.h"

NSString *const Key_Recipe_Title = @"title";
NSString *const Key_Recipe_Excerpt = @"excerpt";
NSString *const Key_Recipe_Description = @"description";
NSString *const Key_Recipe_PubDate = @"pubDate";


@implementation TCHRecipeFeedItem

#pragma mark overrides from FeedItem
- (void)processSavedDictionary:(NSDictionary *)dict {
  self.recipeTitle = dict[Key_Recipe_Title];
  self.recipeExcerpt = dict[Key_Recipe_Excerpt];
  self.recipeDescription = dict[Key_Recipe_Description];
  self.recipePubDate = dict[Key_Recipe_PubDate];
}


- (void)processXMLElement:(CXMLElement *)element andBaseURL:(NSURL *)baseURL {
  self.recipeTitle = [[element nodeForXPath:Key_Recipe_Title error:nil] stringValue];
  self.recipeExcerpt = [[element nodeForXPath:Key_Recipe_Excerpt error:nil] stringValue];
  self.recipeDescription = [[element nodeForXPath:Key_Recipe_Description error:nil] stringValue];
  NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
  [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
  [inputFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
  NSString *dateStr = [[element nodeForXPath:Key_Recipe_PubDate error:nil] stringValue];
  self.recipePubDate = [inputFormatter dateFromString:dateStr];
}


- (void)populateDictionary:(NSMutableDictionary *)dict {
    [super populateDictionary:dict];
    if (self.recipeTitle) dict[Key_Recipe_Title] = self.recipeTitle;
    if (self.recipeExcerpt) dict[Key_Recipe_Excerpt] = self.recipeExcerpt;
    if (self.recipeDescription) dict[Key_Recipe_Description] = self.recipeDescription;
    if (self.recipePubDate) dict[Key_Recipe_PubDate] = self.recipePubDate;
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
