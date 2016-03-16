//
//  FeedFetcher.h
//  Feedonimy
//
//  Created by Ashmit Chhabra on 8/14/14.
//  Copyright (c) 2014 ARO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedFetcher : NSObject
+(NSMutableArray *)URLForTrending;
+(NSMutableArray *)URLForTech;
+(NSMutableArray *)URLForHeadlines;
+(NSMutableArray *)URLForSports;
+(NSMutableArray *)URLForEntertainment;
+(NSMutableArray *)URLForBusiness;
+(NSMutableArray *)URLForGaming;
@end
