//
//  CTCardCell.h
//  CardTilt
//  Feedonimy
//
//  Created by Ashmit Chhabra on 7/24/14.
//  Copyright (c) 2014 ARO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITextView *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *webLabel;
@property (weak, nonatomic) IBOutlet UIButton *webButton;
@property (weak, nonatomic) IBOutlet UIImageView *twImage;
@property (weak, nonatomic) IBOutlet UIButton *twButton;
@property (weak, nonatomic) IBOutlet UIImageView *fbImage;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;


- (void)setupWithDictionary:(NSDictionary *)dictionary atIndex :(NSInteger)index;
@end
