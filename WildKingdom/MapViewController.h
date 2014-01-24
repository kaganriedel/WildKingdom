//
//  MapViewController.h
//  WildKingdom
//
//  Created by Kagan Riedel on 1/24/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController
@property (nonatomic) IBOutlet MKMapView *map;
@property NSDictionary *photoInfo;

@end
