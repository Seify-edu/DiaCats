//
//  FlickrViewController.m
//  DiaCats
//
//  Created by Roman S on 07.10.16.
//  Copyright © 2016 RomanS. All rights reserved.
//

#import "FlickrViewController.h"
#import "FKAuthViewController.h"
#import "FlickrKit.h"
#import "MapViewController.h"

@interface FlickrViewController ()
@property (nonatomic, strong) FKDUNetworkOperation *checkAuthOp;
@property (nonatomic, strong) FKDUNetworkOperation *completeAuthOp;
@property (nonatomic, strong) NSString *userID;
@end

@implementation FlickrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthenticateCallback:) name:@"UserAuthCallbackNotification" object:nil];
    
    // Check if there is a stored token
    self.authButton.enabled = NO;
    [self.authLabel setText:@"Checking Flickr login..."];
    self.searchButton.enabled = NO;
    self.checkAuthOp = [[FlickrKit sharedFlickrKit] checkAuthorizationOnCompletion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.authButton.enabled = YES;
            if (!error) {
                [self userLoggedIn:userName userID:userId];
            } else {
                [self userLoggedOut];
            }
        });		
    }];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void) viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;

    [self.completeAuthOp cancel];
    [self.checkAuthOp cancel];
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Auth

- (IBAction)authPressed
{
    if ([FlickrKit sharedFlickrKit].isAuthorized) {
        [[FlickrKit sharedFlickrKit] logout];
        [self userLoggedOut];
    } else {
        FKAuthViewController *authView = [[FKAuthViewController alloc] init];
        [self.navigationController pushViewController:authView animated:YES];
    }	
};

- (void)userAuthenticateCallback:(NSNotification *)notification
{
    NSURL *callbackURL = notification.object;
    self.completeAuthOp = [[FlickrKit sharedFlickrKit] completeAuthWithURL:callbackURL completion:^(NSString *userName, NSString *userId, NSString *fullName, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [self userLoggedIn:userName userID:userId];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
}

- (void)userLoggedIn:(NSString *)username userID:(NSString *)userID
{
    self.userID = userID;
    [self.authButton setTitle:@"Logout" forState:UIControlStateNormal];
    self.authLabel.text = [NSString stringWithFormat:@"You are logged in as %@", username];
    self.searchButton.enabled = YES;
}

- (void)userLoggedOut
{
    [self.authButton setTitle:@"Login" forState:UIControlStateNormal];
    self.authLabel.text = @"Need to login. Use test account:\rUsername: test.diacats@gmail.com\rPass: testdiacats";
    self.searchButton.enabled = NO;
}

#pragma mark - Search

- (IBAction)searchPressed
{
    [self.searchTextField endEditing:YES];
    
    FKFlickrPhotosSearch *search = [[FKFlickrPhotosSearch alloc] init];
    search.text = self.searchTextField.text;
    search.per_page = @"15";
    search.has_geo = @"1";
    search.extras = @"geo";
    [[FlickrKit sharedFlickrKit] call:search completion:^(NSDictionary *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response) {
                NSMutableArray *photosInfo = [NSMutableArray array];
                for (NSDictionary *photoDictionary in [response valueForKeyPath:@"photos.photo"])
                {
                    MapPhotoInfo *info = [[MapPhotoInfo alloc] init];
                    info.url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoDictionary];
                    info.longitude = photoDictionary[@"longitude"];
                    info.latitude = photoDictionary[@"latitude"];
                    [photosInfo addObject:info];
                }
                
                MapViewController *mvc = [[MapViewController alloc] initWithPhotosInfo:photosInfo];
                [self.navigationController pushViewController:mvc animated:YES];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        });
    }];
}


@end
