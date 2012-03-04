//
//  sharethissongMainViewController.m
//  Share This Song
//
//  Created by Jocelyn Nourry on 30/10/11.
//  Copyright (c) 2011 Personal. All rights reserved.
//

#import "sharethissongMainViewController.h"
#import "sharethissongAppDelegate.h"
#import "JSON.h"


@implementation sharethissongMainViewController

@synthesize flipsidePopoverController = _flipsidePopoverController;

// Player musical
@synthesize musicPlayer;

// Elements d'UI
@synthesize Songlabel;
@synthesize Artistlabel;        
@synthesize Albumlabel;
@synthesize fbOnOfflabel;
@synthesize progressionlabel;
@synthesize shareButton; 
@synthesize facebookButton; 
@synthesize artworkImageView;
@synthesize editablemsg;

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
    artworkImageView.layer.borderColor = [UIColor blackColor].CGColor;
    artworkImageView.layer.borderWidth = 3.0;
    
    // Modification du bouton de partage
    shareButton.layer.masksToBounds = YES;
    shareButton.layer.cornerRadius = 8.0;
    [shareButton setTitleColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.8] forState:UIControlStateNormal];
    shareButton.layer.borderColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.6].CGColor;
    shareButton.layer.borderWidth = 1.5;
    
    // Would simply display a grey background
    //[shareButton setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.75]];
    
    // Sets a gradient on button's background
    CAGradientLayer *shineLayer;
    shineLayer = [CAGradientLayer layer];
    shineLayer.frame = shareButton.layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.75].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.1f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.1f].CGColor,
                         (id)[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.75].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    [shareButton.layer addSublayer:shineLayer];
    
    
    // Modification du bouton Facebook
    facebookButton.layer.masksToBounds = YES;
    facebookButton.layer.cornerRadius = 15.0;
    facebookButton.layer.borderWidth = 1.5;
    
    // La partie player
    musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [self registerMediaPlayerNotifications];
    
    // Display alert “message posted to Facebook” but hidden
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    tempLabel.numberOfLines = 0;   //To allow line breaks :)
    
    [self changeMessageText:NSLocalizedString(@"Message posted to Facebook",@"")];
    
    tempLabel.backgroundColor = [UIColor colorWithWhite:0.20 alpha:1.0];
    tempLabel.textColor = [UIColor whiteColor];
    tempLabel.layer.borderColor = [[UIColor grayColor] CGColor];
    tempLabel.layer.borderWidth = 1.5;
    tempLabel.layer.cornerRadius = 6.0;
    
    [self.view addSubview:tempLabel];
    tempLabel.alpha = 0.0f;
    
    
    // Modification du Text View avec des bords arrondis et gris
    [editablemsg.layer setMasksToBounds:YES];
    
    editablemsg.layer.cornerRadius = 9.0;
    editablemsg.layer.borderColor = [UIColor grayColor].CGColor;
    editablemsg.layer.borderWidth = 1.5;
    editablemsg.text = NSLocalizedString(@"edit your comment here",@"");
    editablemsg.alpha = 0.6;
    
    addacomment = FALSE;
    
    [self updateSongPlayed];
    
    [self updateFacebookLogo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFBbutton:) name:@"refreshFBbutton" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FBrequestDidLoad:) name:@"FBrequestDidLoad" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beganEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
    
    // Get user preferences and set the switch on if it's the first run
	NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
	if ([userPrefs boolForKey:@"first_run"] == 0)
	{
		// First run
		[userPrefs setBool:1 forKey:@"first_run"];
        [userPrefs setBool:1 forKey:@"artwork_setting"];
		[userPrefs synchronize];
	}
    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                  object: musicPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: @"refreshFBbutton"
                                                  object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: @"FBrequestDidLoad"
                                                  object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: @"editChanged"
                                                  object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: @"beganEditing"
                                                  object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: @"endEditing"
                                                  object: nil];
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
    NSLog(@"updateSongPlayed");
    
    editablemsg.text = NSLocalizedString(@"edit your comment here",@"");
    addacomment = FALSE;

    artworkImageView.layer.borderColor = [UIColor redColor].CGColor;

    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];
    UIImage *artworkImage = [UIImage imageNamed:@"noArtworkImage.png"];
    MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
    
    if (artwork)
        {
        artworkImage = [artwork imageWithSize: CGSizeMake (256, 256)];
        shareButton.alpha = 1.0;
        shareButton.enabled = YES;
        //[shareButton setHidden:NO];   // Won't work, I don't know why
        }
    else
        {
        shareButton.alpha = 0.25;
        shareButton.enabled = NO;
        //[shareButton setHidden:YES];   // Won't work, I don't know why
        }
    
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
    // Get user preferences
	NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    
    BOOL artworkSetting = [userPrefs boolForKey:@"artwork_setting"];

    // if the user wants the app to search for iTunes artwork
    // if not, we post directly :)
    if (artworkSetting)
        {
        NSLog(@"Recherche avec Artwork");
        [self searchImages];
        }
    else
        {
        NSLog(@"Recherche sans Artwork");
        artworkURL = @"";
        iTunesSongURL = @"";
        [self postToFacebook];
        }

}

- (void)searchImages
{
    progressionlabel.text = [NSString stringWithFormat:NSLocalizedString(@"searching for iTunes artwork",@"")];
    
    // On récupère d'abord le code pays
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    
    NSString *myParams = [NSString stringWithFormat:
                          @"%@ %@ %@",
                          Artistlabel.text, 
                          Songlabel.text, 
                          Albumlabel.text];
    
    NSString *myParamsEncoded = (__bridge_transfer NSString * )
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (__bridge CFStringRef)myParams,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    
    NSString *finalString = [NSString stringWithFormat:
                        @"http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStoreServices.woa/wa/itmsSearch?lang=1&output=json&country=%@&term=%@&media=music&limit=1",
                          countryCode,
                          myParamsEncoded];
    
    //http://ajax.googleapis.com/ajax/services/search/images?v=1.0&start=0&num=1&q=
    //http://images.google.com/images?start=0&num=1&q=
    /*
     http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStoreServices.woa/wa/itmsSearch?lang=1&output=json&country=%@&term=%@&media=%@&limit=1
     ou plus simple
     http://itunes.apple.com/search?lalistedeparametres
     */
    
    NSURL *url = [NSURL URLWithString:finalString];
    NSLog(@"url : %@",url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.shouldAttemptPersistentConnection   = NO;
    [ASIHTTPRequest setDefaultTimeOutSeconds:10];


    [request setDelegate:self];
    [request startAsynchronous];
}


// We have the response from iTunes
- (void)requestFinished:(ASIHTTPRequest *)request
{
    progressionlabel.text = [NSString stringWithFormat:NSLocalizedString(@"iTunes artwork found",@"")];

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

    progressionlabel.text = [NSString stringWithFormat:NSLocalizedString(@"iTunes request failed",@"")];
    
    // We still post to Facebook, but there won't be any artwork link
    [self postToFacebook];

}

// Post on the user's wall
- (void)postToFacebook
{
    progressionlabel.text = [NSString stringWithFormat:NSLocalizedString(@"posting to Facebook",@"")];

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
        iTunesSongURL = @"http://www.itunes.com";
        }
    
    if (addacomment) 
    {
        NSDictionary *properties = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           editablemsg.text,@">", 
                                           nil];
        SBJsonWriter *writer = [SBJsonWriter alloc];
        NSString *propStr = [writer stringWithObject:properties];
        
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  messageShareThisSong, @"message", 
                  artworkURL, @"picture",
                  Artistlabel.text, @"name",
                  Songlabel.text, @"caption",
                  Albumlabel.text, @"description",
                  iTunesSongURL, @"link",
                  propStr,@"properties",
                  nil];
    }
    else
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
    
    // Si on voulait ajouter un commentaire : avec le result de FBrequest
    /*[facebook requestWithGraphPath:[NSString stringWithFormat:@"/%@/comments",id_result] 
                        andParams:params 
                        andHttpMethod:@"POST" 
                        andDelegate:self];*/

}


- (void) updateFacebookLogo
{
    sharethissongAppDelegate *appDelegate = (sharethissongAppDelegate *)[[UIApplication sharedApplication] delegate];
    Facebook *theFacebook = [appDelegate facebook];

    if ([theFacebook isSessionValid])
        {
        facebookButton.layer.borderColor = [UIColor greenColor].CGColor;
        facebookButton.alpha = 1.0;
        [shareButton setHidden:NO];
        fbOnOfflabel.text = @"on";
        fbOnOfflabel.textColor = [UIColor greenColor];
        }
    else
        {
        facebookButton.layer.borderColor = [UIColor redColor].CGColor;
        facebookButton.alpha = 0.5;
        [shareButton setHidden:YES];
        fbOnOfflabel.text = @"off";
        fbOnOfflabel.textColor = [UIColor redColor];
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
                                  message:NSLocalizedString(@"Do you really want to log out ?",@"")
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
        [theFacebook logout];
        [self updateFacebookLogo];
	}
}

-(void)refreshFBbutton:(NSNotification *) notification
{
    [self updateFacebookLogo];

}

-(void)FBrequestDidLoad:(NSNotification *) notification
{    
    NSLog(@"FBrequestDidLoad");
    
    addacomment = FALSE;
    
    progressionlabel.text = [NSString stringWithFormat:NSLocalizedString(@"FB request did load",@"")];

    if (iTunesSongURL != @"http://www.itunes.com")
        [self changeMessageText:NSLocalizedString(@"Message posted to Facebook",@"")];
    else
        [self changeMessageText:NSLocalizedString(@"Message posted to Facebook\nwithout iTunes artwork",@"")];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f]; 
    tempLabel.hidden = FALSE;
    tempLabel.alpha = 1.0f;
    
    tempLabel.transform = CGAffineTransformMakeScale(1.1, 1.1); //grow
    [UIView commitAnimations];
    
    // Will fade the message label in 3 seconds
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(fadeMessage) userInfo:nil repeats:NO];
    
}

-(void)fadeMessage
{
    // Remove label with fade out
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.0f]; 
    // Remove label
    tempLabel.alpha = 0.0f;
    tempLabel.transform = CGAffineTransformMakeScale(1.0, 1.0); //normal

    // Changer la couleur du bord de l’image 
    //  - en vert si la pochette est transmise
    //  - en orange sinon
    if (iTunesSongURL != @"http://www.itunes.com")
        artworkImageView.layer.borderColor = [UIColor greenColor].CGColor;
    else
        artworkImageView.layer.borderColor = [UIColor orangeColor].CGColor;
    
    progressionlabel.text = @"";
    [UIView commitAnimations];
}

-(void)changeMessageText:(NSString *)messageText
{
    [tempLabel setText:NSLocalizedString(messageText,@"")];
    
    // La taille max selon le type de iDevice
    CGSize boundingSize;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        boundingSize = CGSizeMake(250, 60);
    else
        boundingSize = CGSizeMake(350, 80);
    
    
    // Recoupe le cadre du label en function du texte
    CGSize labelSize = [tempLabel.text sizeWithFont:tempLabel.font
                                  constrainedToSize:boundingSize
                                      lineBreakMode:tempLabel.lineBreakMode];
    
    // Permet d’agrandir légèrement autour du texte (plus joli)
    tempLabel.frame = CGRectMake(
                                 0,
                                 0,
                                 1.25 * labelSize.width, 
                                 1.25 * labelSize.height);
    
    [tempLabel setTextAlignment:UITextAlignmentCenter];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        [tempLabel setCenter:CGPointMake(kiPhoneWidth/2.0, kiPhoneHeight/2.0)];
    else
        [tempLabel setCenter:CGPointMake(kiPadHeight/2.0, kiPadWidth/2.0)];
    
}

-(void)beganEditing:(NSNotification *)notification 
{
    NSLog(@"UITextViewTextDidBeginEditingNotification");

    if (!addacomment) 
    {
        editablemsg.text = @"";
    }
    editablemsg.alpha = 1.0;
}

-(void)editChanged:(NSNotification *)notification 
{
    NSLog(@"UITextViewTextDidChangeNotification");
    if (![editablemsg.text isEqualToString:@""])
        {
        NSLog(@"Message édité : %@",editablemsg.text);
        addacomment = TRUE;
            
        // Pour se remettre sur l'écran dès qu'on touche Done
        if([editablemsg.text hasSuffix:@"\n"])
            [editablemsg resignFirstResponder];
        }
}

-(void)endEditing:(NSNotification *)notification 
{
    NSLog(@"UITextViewTextDidEndEditingNotification");
    
    editablemsg.alpha = 0.6;
}

// Pour se remettre sur l'écran si on touche en dehors du clavier
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [editablemsg resignFirstResponder];
}

@end
