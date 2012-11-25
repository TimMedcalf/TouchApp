//
//  CatalogueItem.m
//  TouchApp
//
//  Created by Tim Medcalf on 08/08/2011.
//  Copyright 2011 ErgoThis Ltd. All rights reserved.
//

//keys for XML and Dictionaries
NSString *const Key_Cat_Title = @"title";
NSString *const Key_Cat_Artist = @"artist";
NSString *const Key_Cat_CatalogueNumber = @"catalogue_number";
NSString *const Key_Cat_Description = @"description";
NSString *const Key_Cat_MP3SampleURL = @"mp3_sample_url";
NSString *const Key_Cat_CoverArt = @"cover_art_url";
NSString *const Key_Cat_ReleaseURL = @"release_url";
NSString *const Key_Cat_Itunes_URL = @"itunes_url";
NSString *const Key_Cat_ReleaseDate = @"release_date";
NSString *const Key_Cat_ReleaseDuration = @"release_duration";
NSString *const Key_Cat_TrackListing = @"track_listing";
NSString *const Key_Cat_Publisher = @"publisher";


#import "CatalogueItem.h"

@implementation CatalogueItem

@synthesize title = _title;
@synthesize artist = _artist;
@synthesize catalogueNumber = _catalogueNumber;
@synthesize description = _description;
@synthesize mp3SampleURL = _mp3SampleURL;
@synthesize releaseURL = _releaseURL;
@synthesize itunesURL = _itunesURL;
@synthesize releaseDateString = _releaseDateString;
@synthesize releaseDuration = _releaseDuration;
@synthesize trackListing = _trackListing;
@synthesize publisher = _publisher;

#pragma mark lifecycle


#pragma mark overrides from FeedItem
- (void)procesSavedDictionary:(NSDictionary *)dict
{
  self.title = dict[Key_Cat_Title];
  self.artist = dict[Key_Cat_Artist];
  self.catalogueNumber = dict[Key_Cat_CatalogueNumber];
  self.description = dict[Key_Cat_Description];
  self.mp3SampleURL = dict[Key_Cat_MP3SampleURL];
  self.releaseURL = dict[Key_Cat_ReleaseURL];
  self.itunesURL = dict[Key_Cat_Itunes_URL];
  self.releaseDateString = dict[Key_Cat_ReleaseDate];
  self.releaseDuration = dict[Key_Cat_ReleaseDuration];
  self.trackListing = dict[Key_Cat_TrackListing];
  self.publisher = dict[Key_Cat_Publisher];
}

- (void)processXMLDictionary:(NSDictionary *)dict andBaseURL:(NSURL *)baseURL
{ 
  //lets get the parent fields out the way first
  NSString *tmpImage = dict[Key_Cat_CoverArt];
  if (tmpImage)
  {
    NSURL *tmpURL = [[NSURL alloc] initWithString:tmpImage relativeToURL:baseURL];
    self.imageURL = tmpURL;
  }
  //okay, now the stuff that's unique to us...
  self.title = dict[Key_Cat_Title];
  self.artist = dict[Key_Cat_Artist];
  self.catalogueNumber = dict[Key_Cat_CatalogueNumber];
    
  self.description = [[dict[Key_Cat_Description]
                      stringByReplacingOccurrencesOfString:@"\n\n" 
                      withString:@"</p><p>"] stringByReplacingOccurrencesOfString:@"\r\n" withString:@"</p><p>"];

  self.mp3SampleURL = [dict[Key_Cat_MP3SampleURL] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  self.releaseURL = [dict[Key_Cat_ReleaseURL] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  self.itunesURL = [dict[Key_Cat_Itunes_URL] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  self.releaseDateString = dict[Key_Cat_ReleaseDate];
  self.releaseDuration = dict[Key_Cat_ReleaseDuration];
  self.trackListing = [dict[Key_Cat_TrackListing]
                         stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
  self.publisher = dict[Key_Cat_Publisher];
  //NSLog(@"%@ - %@ - %@", self.catalogueNumber, self.artist, self.title);
}

- (void)populateDictionary:(NSMutableDictionary *)dict
{
  dict[Key_Cat_Title] = self.title;
  dict[Key_Cat_Artist] = self.artist;
  dict[Key_Cat_CatalogueNumber] = self.catalogueNumber;
  dict[Key_Cat_Description] = self.description;
  dict[Key_Cat_MP3SampleURL] = self.mp3SampleURL;
  dict[Key_Cat_ReleaseURL] = self.releaseURL;
  dict[Key_Cat_Itunes_URL] = self.itunesURL;
  dict[Key_Cat_ReleaseDate] = self.releaseDateString;
  dict[Key_Cat_ReleaseDuration] = self.releaseDuration;
  dict[Key_Cat_TrackListing] = self.trackListing;
  dict[Key_Cat_Publisher] = self.publisher;
}

- (NSString *)htmlForWebView
{
  NSString *streamLink = @"";
  if ((self.mp3SampleURL) && ([self.mp3SampleURL length] > 0))
  {
    streamLink = @"<div id='playerwrapper'><div><strong>Play</strong><br /><span class='subtitle'>Tap here to stream audio</span></div></div>";
  }
  
  NSString *catalogueNumberReleaseDateDiv = @"";
  if ((self.releaseDateString) && ([self.releaseDateString length] > 0)) {
      NSDateFormatter *dateFormatSource = [[NSDateFormatter alloc] init];
      [dateFormatSource setDateFormat:@"yyyy-MM-d"];
      
      NSDateFormatter *dateFormatDestination = [[NSDateFormatter alloc] init];
      [dateFormatDestination setDateFormat:@"d MMMM yyyy"];
      
      NSDate *formattedDate = [dateFormatSource dateFromString:self.releaseDateString];
      
      NSString *releaseDateStringReformatted = [dateFormatDestination stringFromDate:formattedDate]; 
      
    
      catalogueNumberReleaseDateDiv = [NSString stringWithFormat:@"<span id='release_date'>Released: %@</span>",releaseDateStringReformatted];
  }
  
  if (((self.releaseDateString) && ([self.releaseDateString length] > 0)) && ((self.catalogueNumber) && ([self.catalogueNumber length] > 0))) {
      catalogueNumberReleaseDateDiv = [NSString stringWithFormat:@"%@&nbsp;&nbsp;|&nbsp;&nbsp;",catalogueNumberReleaseDateDiv];
  }
    
  if ((self.catalogueNumber) && ([self.catalogueNumber length] > 0)) {
    catalogueNumberReleaseDateDiv = [NSString stringWithFormat:@"%@<span id='catalogue_number'>Catalogue #: %@</span>",catalogueNumberReleaseDateDiv,self.catalogueNumber];
  }
    
  NSString *trackListingDiv = @"";
  if ((self.trackListing) && ([self.trackListing length] > 0))
  {
      trackListingDiv = [NSString stringWithFormat:@"<div id=\"tracklistingcontainer\"><p id=\"tracklisting\"><p>Track listing:</p><p>%@</p></div>",self.trackListing];
  }

  NSString *buyLink = @"";
  
  if ((self.itunesURL) && ([self.itunesURL length] > 0))
  {
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
          self.title,self.artist,catalogueNumberReleaseDateDiv,self.imageURL,trackListingDiv,self.description, streamLink, buyLink];
}






@end
