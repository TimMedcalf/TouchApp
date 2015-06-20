//
//  TCHCatalogueFeedItem.m
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
//keys for XML and Dictionaries
NSString *const Key_Cat_Title = @"title";
NSString *const Key_Cat_Artist = @"artist";
NSString *const Key_Cat_CatalogueNumber = @"catalogue_number";
NSString *const Key_Cat_Text = @"description";
NSString *const Key_Cat_MP3SampleURL = @"mp3_sample_url";
NSString *const Key_Cat_CoverArt = @"cover_art_url";
NSString *const Key_Cat_ReleaseURL = @"release_url";
NSString *const Key_Cat_Itunes_URL = @"itunes_url";
NSString *const Key_Cat_ReleaseDate = @"release_date";
NSString *const Key_Cat_ReleaseDuration = @"release_duration";
NSString *const Key_Cat_TrackListing = @"track_listing";
NSString *const Key_Cat_Publisher = @"publisher";
#pragma clang diagnostic pop

#import "TCHCatalogueFeedItem.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"

@implementation TCHCatalogueFeedItem

#pragma mark lifecycle

#pragma mark overrides from FeedItem
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        self.title = dict[Key_Cat_Title];
        self.artist = dict[Key_Cat_Artist];
        self.catalogueNumber = dict[Key_Cat_CatalogueNumber];
        self.text = dict[Key_Cat_Text];
        self.mp3SampleURL = dict[Key_Cat_MP3SampleURL];
        self.releaseURL = dict[Key_Cat_ReleaseURL];
        self.itunesURL = dict[Key_Cat_Itunes_URL];
        self.releaseDateString = dict[Key_Cat_ReleaseDate];
        self.releaseDuration = dict[Key_Cat_ReleaseDuration];
        self.trackListing = dict[Key_Cat_TrackListing];
        self.publisher = dict[Key_Cat_Publisher];
    }
    return self;
}

- (instancetype)initWithXMLElement:(DDXMLElement *)element andBaseURL:(NSURL *)baseURL {
    self = [super initWithXMLElement:element andBaseURL:baseURL];
    if (self) {
        NSString *tmpImage = [[element elementForName:Key_Cat_CoverArt] stringValue];

        if (tmpImage) {
            NSURL *tmpURL = [[NSURL alloc] initWithString:tmpImage relativeToURL:baseURL];
            self.imageURL = tmpURL;
        }
        //okay, now the stuff that's unique to us...
        self.title = [[element elementForName:Key_Cat_Title] stringValue];
        self.artist = [[element elementForName:Key_Cat_Artist] stringValue];
        self.catalogueNumber = [[element elementForName:Key_Cat_CatalogueNumber] stringValue];

        //tweak text for HTML display
        self.text = [[element elementForName:Key_Cat_Text] stringValue];
        self.text = [self.text stringByReplacingOccurrencesOfString:@"\n\n" withString:@"</p><p>"];
        self.text = [self.text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"</p><p>"];

        self.mp3SampleURL = [[element elementForName:Key_Cat_MP3SampleURL] stringValue];
        self.mp3SampleURL = [self.mp3SampleURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        self.releaseURL = [[element elementForName:Key_Cat_ReleaseURL] stringValue];
        self.releaseURL = [self.releaseURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        self.itunesURL = [[element elementForName:Key_Cat_Itunes_URL] stringValue];
        self.itunesURL = [self.itunesURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        self.releaseDateString = [[element elementForName:Key_Cat_ReleaseDate] stringValue];
        self.releaseDuration = [[element elementForName:Key_Cat_ReleaseDuration] stringValue];

        self.trackListing = [[element elementForName:Key_Cat_TrackListing] stringValue];
        self.trackListing = [self.trackListing stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];

        self.publisher = [[element elementForName:Key_Cat_Publisher] stringValue];
        //NSLog(@"%@ - %@ - %@", self.catalogueNumber, self.artist, self.title);
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    dict[Key_Cat_Title] = self.title;
    dict[Key_Cat_Artist] = self.artist;
    dict[Key_Cat_CatalogueNumber] = self.catalogueNumber;
    dict[Key_Cat_Text] = self.text;
    dict[Key_Cat_MP3SampleURL] = self.mp3SampleURL;
    dict[Key_Cat_ReleaseURL] = self.releaseURL;
    dict[Key_Cat_Itunes_URL] = self.itunesURL;
    dict[Key_Cat_ReleaseDate] = self.releaseDateString;
    dict[Key_Cat_ReleaseDuration] = self.releaseDuration;
    dict[Key_Cat_TrackListing] = self.trackListing;
    dict[Key_Cat_Publisher] = self.publisher;
    return [NSDictionary dictionaryWithDictionary:dict];
}


- (NSString *)htmlForWebView {
  NSString *streamLink = @"";
  
  if ((self.mp3SampleURL) && ((self.mp3SampleURL).length > 0)) {
    streamLink = @"<div id='playerwrapper'><div><strong>Play</strong><br /><span class='subtitle'>Tap here to stream audio</span></div></div>";
  }
  
  NSString *catalogueNumberReleaseDateDiv = @"";
  
  if ((self.releaseDateString) && ((self.releaseDateString).length > 0)) {
      NSDateFormatter *dateFormatSource = [[NSDateFormatter alloc] init];
      dateFormatSource.dateFormat = @"yyyy-MM-d";
      
      NSDateFormatter *dateFormatDestination = [[NSDateFormatter alloc] init];
      dateFormatDestination.dateFormat = @"d MMMM yyyy";
      
      NSDate *formattedDate = [dateFormatSource dateFromString:self.releaseDateString];
      
      NSString *releaseDateStringReformatted = [dateFormatDestination stringFromDate:formattedDate]; 
      
    
      catalogueNumberReleaseDateDiv = [NSString stringWithFormat:@"<span id='release_date'>Released: %@</span>", releaseDateStringReformatted];
  }
  
  if (((self.releaseDateString) && ((self.releaseDateString).length > 0)) && ((self.catalogueNumber) && ((self.catalogueNumber).length > 0))) {
      catalogueNumberReleaseDateDiv = [NSString stringWithFormat:@"%@&nbsp;&nbsp;|&nbsp;&nbsp;", catalogueNumberReleaseDateDiv];
  }
    
  if ((self.catalogueNumber) && ((self.catalogueNumber).length > 0)) {
    catalogueNumberReleaseDateDiv = [NSString stringWithFormat:@"%@<span id='catalogue_number'>Catalogue #: %@</span>", catalogueNumberReleaseDateDiv,self.catalogueNumber];
  }
    
  NSString *trackListingDiv = @"";
  
  if ((self.trackListing) && ((self.trackListing).length > 0)) {
      trackListingDiv = [NSString stringWithFormat:@"<div id=\"tracklistingcontainer\"><p id=\"tracklisting\"><p>Track listing:</p><p>%@</p></div>", self.trackListing];
  }

  NSString *buyLink = @"";
  
  if ((self.itunesURL) && ((self.itunesURL).length > 0)) {
    buyLink = @"<div id='buywrapper'><div><strong>Buy</strong><br /><span class='subtitle'>Tap here to visit the iTunes Store page for this release</span></div></div>";
  }
  //inject some CSS
  //note that strings can be run across multiple lines without having to reassign or append - just make sure quotes are at the start and end of each line
  return [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width\" />"
          "<link rel=\"stylesheet\" media=\"only screen and (max-device-width: 480px)\" href=\"catalogue_item_iphone.css\" />"
          "<link rel=\"stylesheet\" media=\"only screen and (min-device-width: 481px) and (max-device-width: 768px)\" href=\"catalogue_item_ipad.css\" />"
          "<link rel=\"stylesheet\" media=\"only screen and (min-device-width: 481px) and (orientation:landscape)\" href=\"catalogue_item_ipad_landscape.css\" /></head>"
          "<script type=\"text/javascript\" src=\"jquery-1.6.4.min.js\"></script>"
          "<script type=\"text/javascript\" src=\"audiocontrol.js\"></script></head>"
          "<body>"
          "<div id='headerwrapper'>"
          "<div id='headercell'>"
          "<div id='headercellinner'>"
          "<div id='title'>%@</div>"
          "<div id='artist'>%@</div>"
          "<div id='byline'>"
          "%@"
          "</div></div></div></div></div>"
          "<div id=\"bodycopycontainer\"><p class='bodycopy'><p><img src='%@' /></p>"
          "%@"
          "<p id=\"description\">%@</p></p></div>"
          "<div id=\"buttoncontainer\">"
          "%@"
          "%@"
          "</div>"
          "</body></html>", 
          self.title, self.artist, catalogueNumberReleaseDateDiv,self.imageURL,trackListingDiv,self.text, streamLink, buyLink];
}

@end
