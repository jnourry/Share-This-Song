//
//  sharethissongAppDelegate.m
//  Share This Song
//
//  Created by Jocelyn Nourry on 30/10/11.
//  Copyright (c) 2011 Personal. All rights reserved.
//

#import "sharethissongAppDelegate.h"

@implementation sharethissongAppDelegate

@synthesize window = _window;

// Facebook
@synthesize facebook;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    /*
     Step 2. Within the body of the application:didFinishLaunchingWithOptions: method create instance of the Facebook class using your app ID (available from the Developer App):   */
    
    if(![self connected])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                    initWithTitle:NSLocalizedString(@"Network problem",@"")
                    message:NSLocalizedString(@"No internet connection",@"")
                    delegate:self 
                    cancelButtonTitle:@"OK"
                    otherButtonTitles:nil];   
        [alert show];
    }
    else
        [self launchFacebook];  


    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/* For 4.2+ support
 Step 5. Add the application:handleOpenURL: and application:openURL: methods with a call to the facebook instance: 
 The relevant method is called by iOS when the Facebook App redirects to the app during the SSO process. The call to Facebook::handleOpenURL: provides the app with the user's credentials.  */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}

/*
 Step 6. Implement the fbDidLogin method from the FBSessionDelegate implementation. In this method you will save the user's credentials specifically the access token and corresponding expiration date. For simplicity you will save this in the user's preferences - NSUserDefault  */
- (void)fbDidLogin {
    NSLog(@"fbDidLogin");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFBbutton" object:nil];

}


/**
 * Called when the session has expired.
 */
- (void)fbSessionInvalidated {  
    NSLog(@"fbSessionInvalidated");
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception" 
                              message:NSLocalizedString(@"Your session has expired.",@"") 
                              delegate:nil 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil, 
                              nil];
    [alertView show];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFBbutton" object:nil];
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {    
    NSLog(@"fbDidLogout");

    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    /*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];*/
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    NSLog(@"fbDidNotLogin");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFBbutton" object:nil];

}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSLog(@"didLoad");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FBrequestDidLoad" object:nil];

}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"Facebook connection failed",@"")
                          message:[error localizedDescription]
                          delegate:self 
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:
                          nil];   
    [alert show];
    
    NSLog(@"did fail: %@", [error localizedDescription]);
    NSLog(@"Err details: %@", [error description]);

}

- (void)requestLoading:(FBRequest *)request;
{
    NSLog(@"requestLoading");
}

- (void) launchFacebook
{
    
    NSLog(@"launch %@",self.inputView);
    
    facebook = [[Facebook alloc] initWithAppId:@"244717028920397" andDelegate:self];  // Facebook
    
    /* 
     Step 3. Once the instance is created, check for previously saved access token information. (We will show you how to save this information in Step 6.) Use the saved information to set up for a session valid check by assigning the saved information to the facebook access token and expiration date properties. This ensures that your app does not redirect to the facebook app and invoke the auth dialog if the app already has a valid access_token. If you have asked for offline_access extended permission then your access_token will not expire, but can still get invalidated if the user changes their password or uninstalls your app. More information here. */
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    /*
     Step 4. Check for a valid session and if it is not valid call the authorize method which will both log the user in and prompt the user to authorize the app: */
    
    if (![facebook isSessionValid]) {
        NSArray *permissions =  [NSArray arrayWithObjects: @"read_stream", @"offline_access", @"publish_stream", nil];
        [facebook authorize:permissions];
        
        //[facebook authorize:nil];
    }
}

// Test internet connectivity
- (BOOL)connected 
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];  
    NetworkStatus networkStatus = [reachability currentReachabilityStatus]; 
    return !(networkStatus == NotReachable);
}
@end
