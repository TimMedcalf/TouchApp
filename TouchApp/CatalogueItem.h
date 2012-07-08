//
//  CatalogueItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"

@interface CatalogueItem : FeedItem

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSString *catalogueNumber;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *mp3SampleURL;
@property (strong, nonatomic) NSString *releaseURL;
@property (strong, nonatomic) NSString *itunesURL;
@property (strong, nonatomic) NSString *releaseDateString;
@property (strong, nonatomic) NSString *releaseDuration;
@property (strong, nonatomic) NSString *trackListing;
@property (strong, nonatomic) NSString *publisher;

@end
