//
//  CTCardCell.m
//  CardTilt
//
//  Feedonimy
//
//  Created by Ashmit Chhabra on 7/24/14.
//  Copyright (c) 2014 ARO. All rights reserved.
//

#import "CTCardCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CTCardCell () {
    NSString *website;
    NSString *twitter;
    NSString *facebook;
}
@property(nonatomic, strong) NSMutableArray * photosCache;
@end

@implementation CTCardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupWithDictionary:(NSDictionary *)dictionary atIndex :(NSInteger)index{
   // NSLog(@"dictionary %@",dictionary);
    self.mainView.layer.cornerRadius = 10;
    self.mainView.layer.masksToBounds = YES;    

    NSString *imageURLString = [dictionary objectForKey:@"imageURL"];
    NSString * mediaURL = [dictionary objectForKey:@"imageMediaURL"];//[mediaArray objectAtIndex:index];
    NSString * enclosedMediaURL =[dictionary objectForKey:@"enclosedMediaURL"];//[enclosedMediaArray objectAtIndex:index];
    NSString * mediaThumbnailUrl = [dictionary objectForKey:@"mediaThumbnail"];
   // NSLog(@"imageurl = %@,media = %@, enclosed = %@",imageURLString,mediaURL,enclosedMediaURL);
    if([imageURLString length]<1){
        
        if([mediaURL length]>1)
            imageURLString = mediaURL;
        else if([enclosedMediaURL length]>1)
            imageURLString = enclosedMediaURL;
        else
            imageURLString = mediaThumbnailUrl;
    }
    else if([mediaURL length] >1 && [imageURLString length]>1){
        imageURLString = mediaURL;
    }
    else if([enclosedMediaURL length] >1 && [imageURLString length]>1 ){
        imageURLString = enclosedMediaURL;
    }
    else if([mediaThumbnailUrl length] >1 && [imageURLString length]>1 ){
        imageURLString = mediaThumbnailUrl;
    }
    //start downloading image
    //NSLog(@"imageurl = %@",imageURLString);
     NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    
if(![self.photosCache objectAtIndex:index]){
    [self downloadImageWithURL:imageURL completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            // change the image in the cell
           self.profilePhoto.image = image;
            [self.photosCache addObject:image];
            // cache the image for use later (when scrolling up)

        }
    }];
}
else{
    self.profilePhoto.image = [self.photosCache objectAtIndex:index];
}
     NSString *newlineString = @"\n";

    self.nameLabel.text = [dictionary valueForKey:@"title"];
    //[self.nameLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
//    self.nameLabel.numberOfLines = 0;
//    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//
   NSString *descriptionText = [[dictionary valueForKey:@"description"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    descriptionText = [descriptionText stringByReplacingOccurrencesOfString:@"\\n" withString:newlineString];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:descriptionText];
    
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor lightGrayColor]
                             range:NSMakeRange(0, [descriptionText length])];
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:@"TrebuchetMS-Bold" size:12]
                             range:NSMakeRange(0, [descriptionText length])];
    if([descriptionText length]<2){
       
        NSMutableAttributedString * titleAttributedString = [[NSMutableAttributedString alloc]initWithString:[dictionary valueForKey:@"title"]];
        
        [titleAttributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor lightGrayColor]
                                 range:NSMakeRange(0, [descriptionText length])];
        [titleAttributedString addAttribute:NSFontAttributeName
                                 value:[UIFont fontWithName:@"TrebuchetMS-Bold" size:12]
                                 range:NSMakeRange(0, [descriptionText length])];
        self.titleLabel.attributedText = titleAttributedString;
    }
    else{
        self.titleLabel.attributedText = attributedString;
    }
    
    //website = [dictionary valueForKey:@"web"];
    if (website) {
        self.webLabel.text = [dictionary valueForKey:@"web"];
    } else {
        self.webLabel.hidden = YES;
        self.webButton.hidden = YES;
    }
    
    //twitter = [dictionary valueForKey:@"twitter"];
    if (!twitter) {
        self.twImage.hidden = YES;
        self.twButton.hidden = YES;
    } else {
        self.twImage.hidden = NO;
        self.twButton.hidden = NO;
    }
    
    //facebook = [dictionary valueForKey:@"facebook"];
    if (!facebook) {
        self.fbImage.hidden = YES;
        self.fbButton.hidden = YES;
    } else {
        self.fbImage.hidden = NO;
        self.fbButton.hidden = NO;
    }
}
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)launchWeb:(id)sender
{
    if (website) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:website]];
    }
}

- (IBAction)launchTwitter:(id)sender
{
    if (twitter) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:twitter]];
    }
}


- (IBAction)launchFacebook:(id)sender
{
    if (facebook) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:facebook]];
    }
}

@end
