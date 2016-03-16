//
//  SavedArticles.h
//  Feedonimy
//
//  Created by Ashmit Chhabra on 9/15/14.
//  Copyright (c) 2014 ARO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SavedArticles : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSDate * datePublished;
@property (nonatomic, retain) NSDate * dateSaved;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * webURL;
@property (nonatomic, retain) NSString * category;

@end
