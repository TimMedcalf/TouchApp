//
//  CatalogueItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"

@interface CatalogueItem : FeedItem

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSString *catalogueNumber;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *mp3SampleURL;
@property (nonatomic, retain) NSString *releaseURL;
@property (nonatomic, retain) NSString *itunesURL;
@property (nonatomic, retain) NSString *releaseDateString;
@property (nonatomic, retain) NSString *releaseDuration;
@property (nonatomic, retain) NSString *trackListing;
@property (nonatomic, retain) NSString *publisher;

@end
