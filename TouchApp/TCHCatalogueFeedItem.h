//
//  TCHCatalogueFeedItem.h
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#import "TCHBaseFeedItem.h"


@interface TCHCatalogueFeedItem : TCHBaseFeedItem

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *artist;
@property (copy, nonatomic) NSString *catalogueNumber;
@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSString *mp3SampleURL;
@property (copy, nonatomic) NSString *releaseURL;
@property (copy, nonatomic) NSString *itunesURL;
@property (copy, nonatomic) NSString *releaseDateString;
@property (copy, nonatomic) NSString *releaseDuration;
@property (copy, nonatomic) NSString *trackListing;
@property (copy, nonatomic) NSString *publisher;

@end
