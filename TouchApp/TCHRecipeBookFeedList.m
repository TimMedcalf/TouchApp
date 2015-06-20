//
//  TCHRecipeBookFeedList.m
//  TouchApp
//
//  Created by Tim Medcalf on 27/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHRecipeBookFeedList.h"
#import "TCHRecipeFeedItem.h"


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
		returnVal = [NSString stringWithFormat:@"http://www.touchmusic.org.uk/recipebook/%@", dictionary[self.recipeCategory]];
	} else {
		returnVal = [NSString stringWithFormat:@"http://www.touchmusic.org.uk/recipebook/%@.xml", [(self.recipeCategory).lowercaseString stringByReplacingOccurrencesOfString:@" " withString:@""]];
	}
  //NSLog(@"Getting recipe file: %@",returnVal);
  return returnVal;
}

- (NSString *)cacheFilename {
  return [NSString stringWithFormat:@"touchRecipeBook%@", self.recipeCategory];;
}

@end
