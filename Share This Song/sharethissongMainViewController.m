//
//  sharethissongMainViewController.m
//  Share This Song
//
//  Created by Jocelyn Nourry on 30/10/11.
//  Copyright (c) 2011 Personal. All rights reserved.
//

#import "sharethissongMainViewController.h"
#import "sharethissongAppDelegate.h"



@implementation sharethissongMainViewController

@synthesize flipsidePopoverController = _flipsidePopoverController;

// Player musical
@synthesize musicPlayer;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    // La partie player
    musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [self registerMediaPlayerNotifications];
    
    [self updateSongPlayed];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                  object: musicPlayer];
    [musicPlayer endGeneratingPlaybackNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    /*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }*/
    return NO;

}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(sharethissongFlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}


- (void) registerMediaPlayerNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_NowPlayingItemChanged:)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: musicPlayer];
    
    
    [musicPlayer beginGeneratingPlaybackNotifications];
}


- (void) handle_NowPlayingItemChanged: (id) notification
{
    [self updateSongPlayed];
    
}

- (void) updateSongPlayed
{
    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
    UIImage *artworkImage = [UIImage imageNamed:@"noArtworkImage.png"];
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    
    if (artwork) {
        artworkImage = [artwork imageWithSize: CGSizeMake (256, 256)];
    }
    
    [artworkImageView setImage:artworkImage];
    
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString) {
        Songlabel.text = [NSString stringWithFormat:@"%@",titleString];
    } else {
        Songlabel.text = @"Unknown title";
    }
    
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString) {
        Artistlabel.text = [NSString stringWithFormat:@"%@",artistString];
    } else {
        Artistlabel.text = @"Unknown artist";
    }
    
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (albumString) {
        Albumlabel.text = [NSString stringWithFormat:@"%@",albumString];
    } else {
        Albumlabel.text = @"Unknown album";
    }
}

- (IBAction)sharingRequest:(id)sender;
{
    // Cette partie est inutile, on ne peut pas uploader sur le mur de FB seulement (il faut passer par /me/photos sinon :( )
    
    /*MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
    UIImage *artworkImage = [UIImage imageNamed:@"noArtworkImage.png"];
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    
    if (artwork) {
        artworkImage = [artwork imageWithSize: CGSizeMake (90, 90)];
    }
    
    NSData* imageData = UIImageJPEGRepresentation(artworkImage, 90);
    */

    
    /*NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Test message", 
                                   @"message", 
                                   imageData, 
                                   @"source", 
                                   nil];*/    
    
    // Avec ça, ça marche mais ça stocke la photo dans FB... bad
    // [theFacebook requestWithGraphPath:@"me/photos" andParams:params andHttpMethod:@"POST" andDelegate:appDelegate];
    [self searchImages];
    

    
}

- (void)searchImages
{
    // On récupère d'abord le code pays
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    
    NSString *myString = [NSString stringWithFormat:
                        @"http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStoreServices.woa/wa/itmsSearch?lang=1&output=json&country=%@&term=%@ %@ %@&media=music&limit=1",
                          countryCode,
                          Artistlabel.text, 
                          Songlabel.text, 
                          Albumlabel.text];
    
    //http://ajax.googleapis.com/ajax/services/search/images?v=1.0&start=0&num=1&q=
    //http://images.google.com/images?start=0&num=1&q=
    /*
     http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStoreServices.woa/wa/itmsSearch?lang=1&output=json&country=%@&term=%@&media=%@&limit=1"
     ou plus simple
     http://itunes.apple.com/search?lalistedeparametres
     */
    
    NSString *finalString = [myString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    NSURL *url = [NSURL URLWithString:finalString];
    NSLog(@"url : %@",url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.shouldAttemptPersistentConnection   = NO;


    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *theJSONresponseString = [request responseString];
    
    // Alloc and initialize our JSON parser
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    // Actually parsing the JSON
    NSMutableDictionary *jsonDictionary = [parser objectWithString:theJSONresponseString];

    NSArray *resultList = [jsonDictionary objectForKey:@"results"];
    
    artworkURL = @"";
    iTunesSongURL = @"";
    for (NSDictionary* result in resultList)
    {
        artworkURL = [result objectForKey:@"artworkUrl100"];
        iTunesSongURL = [result objectForKey:@"itemLinkUrl"];
    }

    NSLog(@"artworkURL : %@",artworkURL);
    NSLog(@"iTunesSongURL : %@",iTunesSongURL);
   
    [self postToFacebook];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"ASIHTTP failed : %@", [error localizedDescription]);
    NSLog(@"Err details    : %@", [error description]);
}

- (void)postToFacebook
{
    
    NSString *messageShareThisSong = [NSString stringWithFormat:@"écoute %@%@%@%@%@",
                                      Songlabel.text, 
                                      @" de ",
                                      Artistlabel.text, 
                                      @" sur l'album ", 
                                      Albumlabel.text];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if (artworkURL == @"")
        {
        artworkURL = @"http://www.kedwards.com/KavaTunes/itunes/images/no_artwork.gif";
        iTunesSongURL = @"";
        }
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       messageShareThisSong, @"message", 
                                       artworkURL, @"picture",
                                       Artistlabel.text, @"name",
                                       Songlabel.text, @"caption",
                                       Albumlabel.text, @"description",
                                       iTunesSongURL, @"link",
                                       nil];
    NSLog(@"params : %@", params);
    
    sharethissongAppDelegate *appDelegate = (sharethissongAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    Facebook *theFacebook = [appDelegate facebook];
    
    [theFacebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:appDelegate];
}
@end
