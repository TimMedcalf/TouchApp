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

- (void)dealloc
{
  [_title release];
  [_artist release];
  [_catalogueNumber release];
  [_description release];
  [_mp3SampleURL release];
  [_releaseURL release];
  [_itunesURL release];
  [_releaseDateString release];
  [_releaseDuration release];
  [_trackListing release];
  [_publisher release];
  [super dealloc];
}

#pragma mark overrides from FeedItem
- (void)procesSavedDictionary:(NSDictionary *)dict
{
  self.title = [dict objectForKey:Key_Cat_Title];
  self.artist = [dict objectForKey:Key_Cat_Artist];
  self.catalogueNumber = [dict objectForKey:Key_Cat_CatalogueNumber];
  self.description = [dict objectForKey:Key_Cat_Description];
  self.mp3SampleURL = [dict objectForKey:Key_Cat_MP3SampleURL];
  self.releaseURL = [dict objectForKey:Key_Cat_ReleaseURL];
  self.itunesURL = [dict objectForKey:Key_Cat_Itunes_URL];
  self.releaseDateString = [dict objectForKey:Key_Cat_ReleaseDate];
  self.releaseDuration = [dict objectForKey:Key_Cat_ReleaseDuration];
  self.trackListing = [dict objectForKey:Key_Cat_TrackListing];
  self.publisher = [dict objectForKey:Key_Cat_Publisher];
}

- (void)processXMLDictionary:(NSDictionary *)dict andBaseURL:(NSURL *)baseURL
{ 
  //lets get the parent fields out the way first
  NSString *tmpImage = [dict objectForKey:Key_Cat_CoverArt];
  if (tmpImage)
  {
    NSURL *tmpURL = [[NSURL alloc] initWithString:tmpImage relativeToURL:baseURL];
    self.imageURL = tmpURL;
    [tmpURL release];
  }
  //okay, now the stuff that's unique to us...
  self.title = [dict objectForKey:Key_Cat_Title];
  self.artist = [dict objectForKey:Key_Cat_Artist];
  self.catalogueNumber = [dict objectForKey:Key_Cat_CatalogueNumber];
    
  self.description = [[[dict objectForKey:Key_Cat_Description]
                      stringByReplacingOccurrencesOfString:@"\n\n" 
                      withString:@"</p><p>"] stringByReplacingOccurrencesOfString:@"\r\n" withString:@"</p><p>"];

  self.mp3SampleURL = [dict objectForKey:Key_Cat_MP3SampleURL];
  self.releaseURL = [dict objectForKey:Key_Cat_ReleaseURL];
  self.itunesURL = [dict objectForKey:Key_Cat_Itunes_URL];
  self.releaseDateString = [dict objectForKey:Key_Cat_ReleaseDate];
  self.releaseDuration = [dict objectForKey:Key_Cat_ReleaseDuration];
  self.trackListing = [[dict objectForKey:Key_Cat_TrackListing]
                         stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
  self.publisher = [dict objectForKey:Key_Cat_Publisher];
  //NSLog(@"%@ - %@ - %@", self.catalogueNumber, self.artist, self.title);
}

- (void)populateDictionary:(NSMutableDictionary *)dict
{
  [dict setObject:self.title forKey:Key_Cat_Title];
  [dict setObject:self.artist forKey:Key_Cat_Artist];
  [dict setObject:self.catalogueNumber forKey:Key_Cat_CatalogueNumber];
  [dict setObject:self.description forKey:Key_Cat_Description];
  [dict setObject:self.mp3SampleURL forKey:Key_Cat_MP3SampleURL];
  [dict setObject:self.releaseURL forKey:Key_Cat_ReleaseURL];
  [dict setObject:self.itunesURL forKey:Key_Cat_Itunes_URL];
  [dict setObject:self.releaseDateString forKey:Key_Cat_ReleaseDate];
  [dict setObject:self.releaseDuration forKey:Key_Cat_ReleaseDuration];
  [dict setObject:self.trackListing forKey:Key_Cat_TrackListing];
  [dict setObject:self.publisher forKey:Key_Cat_Publisher];
}

- (NSString *)htmlForWebView
{
  NSString *streamLink = @"";
  if ((self.mp3SampleURL) && ([self.mp3SampleURL length] > 0))
  {
    streamLink = @"<div id='playerwrapper'><div><strong>Play</strong><br /><span class='subtitle'>Tap here to stream audio</span></div></div>";
  }
    
  NSString *trackListingLink = @"";
  if ((self.trackListing) && ([self.trackListing length] > 0))
  {
      trackListingLink = [NSString stringWithFormat:@"<div id=\"tracklistingcontainer\"><p id=\"tracklisting\"><p>Track listing:</p><p>%@</p></div>",self.trackListing];
  }

  NSString *buyLink = @"";
  
  if ((self.itunesURL) && ([self.itunesURL length] > 0))
  {
    buyLink = @"<div id='buywrapper'><div><strong>Buy</strong><br /><span class='subtitle'>Tap here to visit the iTunes Store page for this release</span></div></div>";
  }
  //inject some CSS
  //note that strings can be run across multiple lines without having to reassign or append - just make sure quotes are at the start and end of each line
  return [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width\" />"
          "<link rel=\"stylesheet\" media=\"only screen and (max-device-width: 480px)\" href=\"mobile.css\" />"
          "<link rel=\"stylesheet\" media=\"only screen and (min-device-width: 481px) and (max-device-width: 1024px)\" href=\"ipad.css\" />"
          "<script type=\"text/javascript\" src=\"jquery-1.6.4.min.js\"></script>"
          "<script type=\"text/javascript\" src=\"audiocontrol.js\"></script></head>"
          "<body><div id='headerwrapper'><div id='headercell'><div id='title'><strong>%@</strong><br /><span id='byline'>By %@</span></div></div></div>"
          "<div id=\"bodycopycontainer\"><p class='bodycopy'><p><img src='%@' /></p>"
          "%@"
          "<p id=\"description\">%@</p></p></div>"
          "<div id=\"buttoncontainer\">"
          "%@"
          "%@"
          "</div>"
          "</body></html>", 
          self.title,self.artist,self.imageURL,trackListingLink,self.description, streamLink, buyLink];
}






@end
