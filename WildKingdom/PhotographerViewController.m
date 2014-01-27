//
//  PhotographerViewController.m
//  WildKingdom
//
//  Created by Kagan Riedel on 1/25/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "PhotographerViewController.h"
#import "PhotoCollectionViewCell.h"

@interface PhotographerViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    __weak IBOutlet UICollectionView *photoCollectionView;
    
    NSArray *photos;
    
}

@end

@implementation PhotographerViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    [self performJSONRequest];

}

-(void)performJSONRequest
{
    photos = nil;
    [photoCollectionView reloadData];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.people.getPhotos&api_key=1c7b7008c23d7346d825b2a16c2e5c49&user_id=%@&per_page=20&page=1&format=json&nojsoncallback=1", _photoInfo[@"owner"]]];
    
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

-(PhotoCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MorePhotosCell" forIndexPath:indexPath];
    cell.photoDictionary = photos[indexPath.row];
    NSString *urlString = [NSString stringWithFormat: @"http://farm%@.staticflickr.com/%@/%@_%@_q.jpg", cell.photoDictionary[@"farm"], cell.photoDictionary[@"server"], cell.photoDictionary[@"id"], cell.photoDictionary[@"secret"]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [cell.contentView addSubview:imageView];
    
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

@end
