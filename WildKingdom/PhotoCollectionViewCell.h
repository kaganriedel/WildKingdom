//
//  photoCollectionViewCell.h
//  WildKingdom
//
//  Created by Kagan Riedel on 1/23/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property NSDictionary *photoDictionary;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property UIImage *hiddenImage;
@property (weak, nonatomic) IBOutlet UILabel *infoTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewMorePhotos;
@property BOOL isImageShowing;


@end
