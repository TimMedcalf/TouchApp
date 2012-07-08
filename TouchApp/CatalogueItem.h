//
//  CatalogueItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "FeedItem.h"

@interface CatalogueItem : FeedItem

@property (weak, nonatomic) NSString *title;
@property (weak, nonatomic) NSString *artist;
@property (weak, nonatomic) NSString *catalogueNumber;
@property (weak, nonatomic) NSString *description;
@property (weak, nonatomic) NSString *mp3SampleURL;
@property (weak, nonatomic) NSString *releaseURL;
@property (weak, nonatomic) NSString *itunesURL;
@property (weak, nonatomic) NSString *releaseDateString;
@property (weak, nonatomic) NSString *releaseDuration;
@property (weak, nonatomic) NSString *trackListing;
@property (weak, nonatomic) NSString *publisher;

@end
