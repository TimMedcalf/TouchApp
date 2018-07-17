//
//  TCHRecipeBookFeedList.m
//  TouchApp
//
//  Created by Tim Medcalf on 27/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHRecipeBookFeedList.h"
#import "TCHRecipeFeedItem.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
//NSString *const kRecipeBookFeed = @"http://www.touch33.net/recipebook";
NSString *const kRecipeBookFeed = @"http://www.touchmusic.org.uk/recipebook";
#pragma clang diagnostic pop

@implementation TCHRecipeBookFeedList

//overrides

//- (NSInteger)refreshTimerCount
//{
//  return 3600;
//}

- (TCHBaseFeedItem *)newItemWithXMLElement:(DDXMLElement *)element andBaseURL:(NSURL *)baseURL {
  return [[TCHRecipeFeedItem alloc] initWithXMLElement:element andBaseURL:baseURL];
}

- (TCHBaseFeedItem *)newItemWithDictionary:dictionary {
  return [[TCHRecipeFeedItem alloc]initWithDictionary:dictionary];
}

- (NSString *)feedURL {
  NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"RecipeCategories" ofType:@"plist"]];
	NSString *returnVal;
	if (dictionary[self.recipeCategory]) {
		returnVal = [NSString stringWithFormat:@"%@/%@", kRecipeBookFeed,dictionary[self.recipeCategory]];
	} else {
		returnVal = [NSString stringWithFormat:@"%@/%@.xml", kRecipeBookFeed, [(self.recipeCategory).lowercaseString stringByReplacingOccurrencesOfString:@" " withString:@""]];
	}
  DDLogDebug(@"Getting recipe file: %@",returnVal);
  return returnVal;
}

- (NSString *)cacheFilename {
  return [NSString stringWithFormat:@"touchRecipeBook%@", self.recipeCategory];;
}

@end
