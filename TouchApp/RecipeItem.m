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


@end
