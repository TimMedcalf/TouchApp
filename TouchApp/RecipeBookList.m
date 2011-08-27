//
//  RecipeBookList.m
//  TouchApp
//
//  Created by Tim Medcalf on 27/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "RecipeBookList.h"
#import "RecipeItem.h"

@implementation RecipeBookList

@synthesize recipeCategory = _recipeCategory;

//overrides

- (void)dealloc
{
  [_recipeCategory release];
  [super dealloc];
}


- (FeedItem *)initNewItemWithXMLDictionary:itemDict andBaseURL:baseURL
{
  return [[RecipeItem alloc]initWithXMLDictionary:itemDict andBaseURL:baseURL];
}

- (FeedItem *)initNewItemWithDictionary:dictionary
{
  return [[RecipeItem alloc]initWithDictionary:dictionary];
}

- (NSString *)feedURL
{
  NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"RecipeCategories" ofType:@"plist"]]; 
	NSString *returnVal;
	if ([dictionary objectForKey:self.recipeCategory]){
		returnVal = [NSString stringWithFormat:@"http://www.touchmusic.org.uk/recipebook/%@",[dictionary objectForKey:self.recipeCategory]];
	}
	else {
		returnVal = [NSString stringWithFormat:@"http://www.touchmusic.org.uk/recipebook/%@.xml",[self.recipeCategory lowercaseString]];
	}
  [dictionary release]; dictionary = nil;
  return returnVal;
}

- (NSString *)cacheFilename
{
  return [NSString stringWithFormat:@"touchRecipeBook%@",self.recipeCategory];;
}


@end
