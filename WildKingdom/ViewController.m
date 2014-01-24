//
//  ViewController.m
//  WildKingdom
//
//  Created by Kagan Riedel on 1/23/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITabBarDelegate>
{
    NSArray *photos;
    __weak IBOutlet UICollectionView *photoCollectionView;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIView *titleView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self performJSONRequest:@"lion,tiger"];
}



-(void)performJSONRequest:(NSString*)searchString
{
    photos = nil;
    [photoCollectionView reloadData];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.flickr.com/services/feeds/photos_public.gne?tags=%@&format=json&nojsoncallback=1_q", searchString]];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         photos = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError][@"items"];
         NSLog(@"%i",photos.count);
         if (connectionError != nil)
         {
             NSLog(@"error is: %@",connectionError);
         }
         [photoCollectionView reloadData];
     }];
}



#pragma mark UITabBarDelegate

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //do a check to see if the tab bar actually changed. if not, don't want to reload the data
        
        if ([item.title isEqualToString:@"Lions"])
        {
            [self performJSONRequest:@"lion,tiger"];
            titleLabel.text = item.title;
            NSLog(@"selected lions");
        }
        if ([item.title isEqualToString:@"Tigers"])
        {
            NSLog(@"selected tigers");
            [self performJSONRequest:@"lizard"];
            titleLabel.text = item.title;
        }
        if ([item.title isEqualToString:@"Bears"])
        {
            NSLog(@"selected bears");
            [self performJSONRequest:@"fire"];
            titleLabel.text = item.title;
    }
}

#pragma mark UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellID" forIndexPath:indexPath];
    NSDictionary *photo = photos[indexPath.row];
    NSURL *url = [NSURL URLWithString:photo[@"media"][@"m"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    cell.imageView.image = image;
    
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return photos.count;
}

@end
