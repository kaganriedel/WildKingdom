//
//  ViewController.m
//  WildKingdom
//
//  Created by Kagan Riedel on 1/23/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCollectionViewCell.h"
#import "MapViewController.h"
#import "PhotographerViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITabBarDelegate>
{
    NSArray *photos;
    __weak IBOutlet UICollectionView *photoCollectionView;

    __weak IBOutlet UITabBar *rootTabBar;
    
    NSDictionary *seguePhotoDictionary;
    
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self performJSONRequest:@"lions"];
    
    rootTabBar.selectedItem = rootTabBar.items[0];
}

-(void)performJSONRequest:(NSString*)searchString
{
    photos = nil;
    [photoCollectionView reloadData];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=1c7b7008c23d7346d825b2a16c2e5c49&tags=%@&page=1&per_page=20&has_geo=1&sort=relevance&format=json&nojsoncallback=1", searchString]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         photos = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError][@"photos"][@"photo"];
         NSLog(@"%i",photos.count);
         if (connectionError != nil)
         {
             NSLog(@"error is: %@",connectionError);
         }
         [photoCollectionView reloadData];
     }];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(150, 150);
        
        [photoCollectionView setCollectionViewLayout:flowLayout animated:YES];

    } else {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(210, 210);

        [photoCollectionView setCollectionViewLayout:flowLayout animated:YES];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MapSegue"])
    {
        MapViewController *vc = segue.destinationViewController;
        vc.photoInfo = seguePhotoDictionary;
    }
    if ([segue.identifier isEqualToString:@"PhotoSegue"])
    {
        PhotographerViewController *vc = segue.destinationViewController;
        vc.photoInfo = seguePhotoDictionary;
    }
}

#pragma mark UITabBarDelegate

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
        //do a check to see if the tab bar actually changed. if not, don't want to reload the data
        
        if ([item.title isEqualToString:@"Lions"])
        {
            [self performJSONRequest:@"lions"];
            self.navigationItem.title = item.title;
            NSLog(@"selected lions");
        }
        if ([item.title isEqualToString:@"Tigers"])
        {
            NSLog(@"selected tigers");
            [self performJSONRequest:@"tigers"];
            self.navigationItem.title = item.title;
        }
        if ([item.title isEqualToString:@"Bears"])
        {
            NSLog(@"selected bears");
            [self performJSONRequest:@"bears"];
            self.navigationItem.title = item.title;
        }
}

#pragma mark UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    seguePhotoDictionary = cell.photoDictionary;
    
    if (cell.isImageShowing)
    {
        cell.hiddenImage = cell.imageView.image;
        cell.isImageShowing = NO;
        cell.infoTitleLabel.text = cell.photoDictionary[@"title"];
        cell.imageView.alpha = 0.0;
        cell.infoView.alpha = 1.0;
        [UIView transitionFromView:cell.imageView toView:cell.infoView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight completion:nil];
    } else
    {
        [UIView transitionFromView:cell.infoView toView:cell.imageView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight completion:nil];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:cell.hiddenImage];
        [cell.contentView addSubview:imageView];
        cell.isImageShowing = YES;
        cell.imageView.alpha = 1.0;
        cell.infoView.alpha = 0.0;
    }
}

-(PhotoCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellID" forIndexPath:indexPath];
//    cell.photoDictionary = photos[indexPath.row];
//    NSString *urlString = [NSString stringWithFormat: @"http://farm%@.staticflickr.com/%@/%@_%@_q.jpg", cell.photoDictionary[@"farm"], cell.photoDictionary[@"server"], cell.photoDictionary[@"id"], cell.photoDictionary[@"secret"]];
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    UIImage *image = [UIImage imageWithData:data];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    [cell.contentView addSubview:imageView];
//    cell.isImageShowing = YES;
//    return cell;


    
    
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellID" forIndexPath:indexPath];
    cell.photoDictionary = photos[indexPath.row];
    NSString *urlString = [NSString stringWithFormat: @"http://farm%@.staticflickr.com/%@/%@_%@_q.jpg", cell.photoDictionary[@"farm"], cell.photoDictionary[@"server"], cell.photoDictionary[@"id"], cell.photoDictionary[@"secret"]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    cell.imageView.image = image;
    cell.isImageShowing = YES;
    
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (photos.count > 20)
    {
        return 20;
    } else
    {
    return photos.count;
    }
}

/*Known issues
 -Photos don't reappear after infoView appears
 -If user taps on a photo, then another, the map link will always bring them to the most recent photo's map
 -Ideally, a rotated photo would automatically rotate back if you click anywhere else
 -When you navigate to a different tab, or scroll the cells keep the infoView instead of showing the imageView
 */

@end
