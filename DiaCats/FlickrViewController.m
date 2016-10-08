//
//  FlickrViewController.m
//  DiaCats
//
//  Created by Roman S on 07.10.16.
//  Copyright © 2016 RomanS. All rights reserved.
//

#import "FlickrViewController.h"
#import "FlickrKit.h"
#import "MapViewController.h"
#import "DCCacheManager.h"
#import "PhotosInfo.h"

@implementation FlickrViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Search

- (IBAction)searchPressed
{
    [self.searchTextField endEditing:YES];
    
    FKFlickrPhotosSearch *search = [[FKFlickrPhotosSearch alloc] init];
    search.text = self.searchTextField.text;
    search.per_page = @"20";
    search.has_geo = @"1";
    search.extras = @"geo";
    
    if ( [FKDUReachability isOffline] )
    {
        // search cache
        PhotosInfo *cachedPhotosInfo = [DCCacheManager cachedPhotosInfoForText:search.text];
        if ( cachedPhotosInfo )
        {
            MapViewController *mvc = [[MapViewController alloc] initWithPhotosInfo:cachedPhotosInfo];
            [self.navigationController pushViewController:mvc animated:YES];
        }
        else
        {
            NSString *errorMessage = [NSString stringWithFormat:@"No cached data for \"%@\". Try another keyword.", search.text];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No data" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        [[FlickrKit sharedFlickrKit] call:search completion:^(NSDictionary *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (response)
                {
                    PhotosInfo *pInfo = [[PhotosInfo alloc] initWithFlickrResponse:response];
                    [DCCacheManager cachePhotosInfo:pInfo forText:search.text];
                    MapViewController *mvc = [[MapViewController alloc] initWithPhotosInfo:pInfo];
                    [self.navigationController pushViewController:mvc animated:YES];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                }
            });
        }];
    }
}

@end
