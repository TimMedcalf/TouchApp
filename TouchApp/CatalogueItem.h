//
//  CatalogueItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"

@interface CatalogueItem : FeedItem

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *artist;
@property (nonatomic) NSString *catalogueNumber;
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *mp3SampleURL;
@property (nonatomic) NSString *releaseURL;
@property (nonatomic) NSString *itunesURL;
@property (nonatomic) NSString *releaseDateString;
@property (nonatomic) NSString *releaseDuration;
@property (nonatomic) NSString *trackListing;
@property (nonatomic) NSString *publisher;

@end
