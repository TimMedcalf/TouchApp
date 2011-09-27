//
//  RecipeItem.m
//  TouchApp
//
//  Created by Tim Medcalf on 26/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "RecipeItem.h"

NSString *const Key_Recipe_Title = @"title";
NSString *const Key_Recipe_Excerpt = @"excerpt";
NSString *const Key_Recipe_Description = @"description";
NSString *const Key_Recipe_PubDate = @"pubDate";

@implementation RecipeItem

@synthesize recipeTitle = _recipeTitle;
@synthesize recipeExcerpt = _recipeExcerpt;
@synthesize recipeDescription = _recipeDescription;
@synthesize recipePubDate = _recipePubDate;

- (void)dealloc
{
  [_recipeTitle release];
  [_recipeExcerpt release];
  [_recipeDescription release];
  [_recipePubDate release];
  [super dealloc];
}

#pragma mark overrides from FeedItem
- (void)procesSavedDictionary:(NSDictionary *)dict
{
  self.recipeTitle = [dict objectForKey:Key_Recipe_Title];
  self.recipeExcerpt = [dict objectForKey:Key_Recipe_Excerpt];
  self.recipeDescription = [dict objectForKey:Key_Recipe_Description];
  self.recipePubDate = [dict objectForKey:Key_Recipe_PubDate];
}

- (void)processXMLDictionary:(NSDictionary *)dict andBaseURL:(NSURL *)baseURL
{ 
  self.recipeTitle = [dict objectForKey:Key_Recipe_Title];
  self.recipeExcerpt = [dict objectForKey:Key_Recipe_Excerpt];
  self.recipeDescription = [dict objectForKey:Key_Recipe_Description];
  NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
  [inputFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
  [inputFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
  NSString *dateStr = [dict objectForKey:Key_Recipe_PubDate];
  self.recipePubDate = [inputFormatter dateFromString:dateStr];
  [inputFormatter release];  
}

- (void)populateDictionary:(NSMutableDictionary *)dict
{
  if (self.recipeTitle) [dict setObject:self.recipeTitle forKey:Key_Recipe_Title];
  if (self.recipeExcerpt) [dict setObject:self.recipeExcerpt forKey:Key_Recipe_Excerpt];
  if (self.recipeDescription) [dict setObject:self.recipeDescription forKey:Key_Recipe_Description];
  if (self.recipePubDate) [dict setObject:self.recipePubDate forKey:Key_Recipe_PubDate];
}

- (NSComparisonResult)compare:(RecipeItem *)item
{
  //compare in reverse so that we get the newest at the top.
  return [item.recipePubDate compare:self.recipePubDate];
}

- (NSString *)htmlForWebView
{
  //inject some CSS
  //note that strings can be run across multiple lines without having to reassign or append - just make sure quotes are at the start and end of each line
  return [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width\" />"
          "<link rel=\"stylesheet\" media=\"only screen and (max-device-width: 480px)\" href=\"mobile.css\" />"
          "<link rel=\"stylesheet\" media=\"only screen and (min-device-width: 481px) and (max-device-width: 1024px)\" href=\"ipad.css\" /></head>"
          "<body><div id='headerwrapper'><div id='headercell'><div id='title'><strong>%@</strong><br /><span id='byline'>By %@</span></div></div></div>"
          "<div id=\"bodycopycontainer\"><p class='bodycopy'>%@</p></div></body></html>", self.recipeExcerpt,self.recipeTitle,self.recipeDescription];
}



@end
