//
//  SavedArticles+Articles.h
//  Feedonimy
//
//  Created by Ashmit Chhabra on 9/15/14.
//  Copyright (c) 2014 ARO. All rights reserved.
//

#import "SavedArticles.h"

@interface SavedArticles (Articles)
+(void)addArticle:(NSMutableDictionary *)articleDictionary intoManagedObjectContext:(NSManagedObjectContext *)context;
+(NSMutableArray *)fetchArticleFromDatabaseInManagedObjectContext:(NSManagedObjectContext*)context;
+(void)deleteAllArticlesInManagedObjectContext:(NSManagedObjectContext*)context;
+(void)deleteArticleWithTitle:(NSString *)title inManagedObjectContext:(NSManagedObjectContext*)context;
@end
