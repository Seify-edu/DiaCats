//
//  MapViewController.m
//  DiaCats
//
//  Created by Roman S on 07.10.16.
//  Copyright © 2016 RomanS. All rights reserved.
//

#import "MapViewController.h"
#import "MapKit/MapKit.h"

@implementation PhotoAnnotation
@end

@implementation MapPhotoInfo
@end

@interface MapViewController()<MKMapViewDelegate>
@property (strong) NSArray *photosInfo;
@end

@implementation MapViewController

- (instancetype)initWithPhotosInfo:(NSArray *)photosInfo
{
    if ( self = [super init] )
    {
        self.photosInfo = photosInfo;
    }
    
    return self;
};

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for ( MapPhotoInfo *info in self.photosInfo )
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:info.url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
        {
            PhotoAnnotation *annotation = [[PhotoAnnotation alloc] init];
            annotation.image = [[UIImage alloc] initWithData:data];
            annotation.coordinate = CLLocationCoordinate2DMake(info.latitude.doubleValue, info.longitude.doubleValue );
            [self.mapView addAnnotation:annotation];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView* aView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:@"MyCustomAnnotation"];
    aView.image = ((PhotoAnnotation *)annotation).image;
    float scale = MIN( 30./aView.image.size.width, 30./aView.image.size.height );
    aView.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
    return aView;
};

@end
