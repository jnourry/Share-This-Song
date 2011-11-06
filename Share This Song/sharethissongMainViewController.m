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

// Elements d'UI
@synthesize Songlabel;
@synthesize Artistlabel;        
@synthesize Albumlabel;
@synthesize shareButton; 
@synthesize artworkImageView;

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
    
    // Modification du titre du bouton (selon la langue)
    [self.shareButton setTitle:NSLocalizedString(@"Share",@"")
                        forState:UIControlStateNormal];

    // Modification de l'Image View avec des bords arrondis et noirs
    [artworkImageView.layer setMasksToBounds:YES];
    
    artworkImageView.layer.cornerRadius = 9.0;
    artworkImageView.layer.masksToBounds = YES;
    artworkImageView.layer.borderColor = [UIColor blackColor].CGColor;
    artworkImageView.layer.borderWidth = 3.0;
    
    // Modification de l'image du bouton
    UIImage *ButtonImage = [UIImage imageNamed:@"Grey Button.png"];
    UIImage *stretchableButton = [ButtonImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [shareButton setBackgroundImage:stretchableButton forState:UIControlStateNormal];
    
    
    // La partie player
    musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [self registerMediaPlayerNotifications];
    
    [self updateSongPlayed];
    
    [self afficherFacebookLogo]; //temp

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
    
    // Si c'est un iPhone : portrait, si c'est un iPad : paysage 
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            if (interfaceOrientation == UIDeviceOrientationPortrait)
                return YES;
            else
                return NO;
        }
    else
        {
            if (interfaceOrientation == UIDeviceOrientationPortrait)
                return NO;
            else
                return YES;
        }

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
    
    if (artwork)
        {
        artworkImage = [artwork imageWithSize: CGSizeMake (256, 256)];
        [shareButton setHidden:NO];
        }
    else
        [shareButton setHidden:YES];
    
    
    [artworkImageView setImage:artworkImage];
    
    NSString *titleString = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    if (titleString) {
        Songlabel.text = [NSString stringWithFormat:@"%@",titleString];
    } else {
        Songlabel.text = NSLocalizedString(@"No track being played",@"");
    }
    
    NSString *artistString = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    if (artistString) {
        Artistlabel.text = [NSString stringWithFormat:@"%@",artistString];
    } else {
        Artistlabel.text = @"";
    }
    
    NSString *albumString = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    if (albumString) {
        Albumlabel.text = [NSString stringWithFormat:@"%@",albumString];
    } else {
        Albumlabel.text = @"";
    }
}

- (IBAction)sharingRequest:(id)sender;
{
    
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
     http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStoreServices.woa/wa/itmsSearch?lang=1&output=json&country=%@&term=%@&media=%@&limit=1
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


// We have the response from iTunes
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

// Pas de retour
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"iTunes request failed",@"")
                          message:[error localizedDescription]
                          delegate:self 
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];   
    [alert show];
    NSLog(@"ASIHTTP failed : %@", [error localizedDescription]);
    NSLog(@"Err details    : %@", [error description]);
}

// Post on the user's wall
- (void)postToFacebook
{
    NSString *messageShareThisSong = [NSString stringWithFormat:NSLocalizedString(@"listens to %@%@%@%@%@",@""),
                                      Songlabel.text, 
                                      NSLocalizedString(@" from ",@""),
                                      Artistlabel.text, 
                                      NSLocalizedString(@" on the album ",@""),
                                      Albumlabel.text];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    // Si l'artwork est introuvable sur iTunes, on affiche une image dispo sur internet
    if (artworkURL == @"")
        {
        artworkURL = @"http://www.kedwards.com/KavaTunes/itunes/images/no_artwork.gif";
        iTunesSongURL = @" ";
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


- (void) afficherFacebookLogo
{
    sharethissongAppDelegate *appDelegate = (sharethissongAppDelegate *)[[UIApplication sharedApplication] delegate];
    Facebook *theFacebook = [appDelegate facebook];

    if ([theFacebook isSessionValid])
        {
        // Enlever le bouton facebook
            
        NSLog(@"afficherFacebookLogo");
        UIButton *facebookLogoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        facebookLogoButton.frame = CGRectMake(18, 412, 20, 20);
        UIImage *facebookLogoImage = [UIImage imageNamed:@"facebook-little.png"];
        [facebookLogoButton setBackgroundImage:facebookLogoImage forState:UIControlStateNormal];
        
        [facebookLogoButton addTarget:self action:@selector(facebookAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:facebookLogoButton];
        }
    else
        {
        NSLog(@"afficherFacebookConnect");
        UIButton *facebookConnectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        facebookConnectButton.frame = CGRectMake(18, 412, 100, 20);
        UIImage *facebookConnectImage = [UIImage imageNamed:@"facebook-connect.png"];
        [facebookConnectButton setBackgroundImage:facebookConnectImage forState:UIControlStateNormal];
        
        [facebookConnectButton addTarget:self action:@selector(facebookAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:facebookConnectButton];

        }
}


- (IBAction)facebookAction:(id)sender;
{
    NSLog(@"facebookAction");
    sharethissongAppDelegate *appDelegate = (sharethissongAppDelegate *)[[UIApplication sharedApplication] delegate];
    Facebook *theFacebook = [appDelegate facebook];
    
    if ([theFacebook isSessionValid])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"Logout from Facebook",@"")
                                  message:NSLocalizedString(@"Do you really want to log out",@"")
                                  delegate:self 
                                  cancelButtonTitle:NSLocalizedString(@"Cancel",@"")
                                  otherButtonTitles:@"OK", nil]; 
            [alert show];
        }
    else
        {
        NSArray *permissions =  [NSArray arrayWithObjects: @"read_stream", @"offline_access", @"publish_stream", nil];
        [theFacebook authorize:permissions];
        }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    sharethissongAppDelegate *appDelegate = (sharethissongAppDelegate *)[[UIApplication sharedApplication] delegate];
    Facebook *theFacebook = [appDelegate facebook];
	if (buttonIndex == 0) {
        NSLog(@"user pressed Cancel");

	}
	else {
        NSLog(@"user pressed OK");
        [theFacebook logout:appDelegate];
	}
}

@end
