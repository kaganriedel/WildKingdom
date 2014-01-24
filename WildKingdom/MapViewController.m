//
//  MapViewController.m
//  WildKingdom
//
//  Created by Kagan Riedel on 1/24/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://api.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=1c7b7008c23d7346d825b2a16c2e5c49&photo_id=%@&format=json&nojsoncallback=1", _photoInfo[@"id"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *locationDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError][@"photo"][@"location"];
         NSLog(@"%@",locationDictionary);
         if (connectionError != nil)
         {
             NSLog(@"error is: %@",connectionError);
         }
         
         MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
         NSString *latitudeString = locationDictionary[@"latitude"];
         double latitude = latitudeString.doubleValue;
         NSString *longitudeString = locationDictionary[@"longitude"];
         double longitude = longitudeString.doubleValue;
         
         CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
         MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
         
         [_map setRegion:region animated:YES];
         
         MKPointAnnotation *pointAnnotation = [MKPointAnnotation new];
         pointAnnotation.coordinate = coordinate;
         pointAnnotation.title = locationDictionary[@"county"][@"_content"];
         
         [_map addAnnotation:pointAnnotation];
         
         //next step! set an MKMapAnnotation to this location!
     }];

}



@end
