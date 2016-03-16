//
//  SavedArticles+Articles.m
//  Feedonimy
//
//  Created by Ashmit Chhabra on 9/15/14.
//  Copyright (c) 2014 ARO. All rights reserved.
//

#import "SavedArticles+Articles.h"

@implementation SavedArticles (Articles)
+(void)addArticle:(NSMutableDictionary *)articleDictionary intoManagedObjectContext:(NSManagedObjectContext *)context{
    NSLog(@"context = %@",context);
    SavedArticles * savedArticle = nil;
    // NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"SavedArticles"];
    
    savedArticle = [NSEntityDescription insertNewObjectForEntityForName:@"SavedArticles" inManagedObjectContext:context];
    savedArticle.title = [articleDictionary objectForKey:@"articleTitle"];
    savedArticle.summary = [articleDictionary objectForKey:@"summary"];
    savedArticle.imageURL = [articleDictionary objectForKey:@"imageURL"];
    savedArticle.webURL = [articleDictionary objectForKey:@"webURL"];
    savedArticle.category = [articleDictionary objectForKey:@"category"];
    savedArticle.datePublished = [articleDictionary objectForKey:@"datePublished"];
    savedArticle.dateSaved = [NSDate date];
    
    
}
+(NSMutableArray *)fetchArticleFromDatabaseInManagedObjectContext:(NSManagedObjectContext*)context{
    NSMutableArray * feedsArray = [[NSMutableArray alloc]init];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"SavedArticles"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateSaved" ascending:NO]];
    NSError * error;
    
    NSArray * matches = [context executeFetchRequest:request error:&error];
    // NSLog(@"matches = %@",matches);
    SavedArticles * article = nil;
//    if (!matches || ([matches count] > 1 || error)) {
//        NSLog(@"failed in saving");
//    } else
    if ([matches count] == 0) {
        article = nil;
        NSLog(@"not saved");
    } else {
        for(article in matches){
            //NSLog(@"artilce , %@",article.title);
            NSMutableDictionary * item = [[NSMutableDictionary alloc]init];
            [item setObject:article.title forKey:@"title"];
            [item setObject:article.webURL forKey:@"link"];
            [item setObject:article.summary forKey:@"description"];
            [item setObject:article.imageURL forKey:@"imageURL"];
            [item setObject:@"" forKey:@"mediaThumbnail"];
            [item setObject:@"" forKey:@"imageMediaURL"];
            [item setObject:@"" forKey:@"enclosedMediaURL"];
            [item setObject:article.datePublished forKey:@"publishedDate"];
            
            [feedsArray addObject:[item copy]];
        }
    }
    //NSLog(@"feedsarray = %@",feedsArray);
    return feedsArray;
}
+(void)deleteAllArticlesInManagedObjectContext:(NSManagedObjectContext*)context{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"SavedArticles"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateSaved" ascending:NO]];
    NSError * error;
    
    NSArray * matches = [context executeFetchRequest:request error:&error];
    // NSLog(@"matches = %@",matches);
    
    for(SavedArticles * article in matches){
        [context deleteObject:article];
    }
    NSError *saveError = nil;
    [context save:&saveError];
}
+(void)deleteArticleWithTitle:(NSString *)title inManagedObjectContext:(NSManagedObjectContext*)context{
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"SavedArticles"];
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@",title];
   
    NSError * error;
    
    NSArray * matches = [context executeFetchRequest:request error:&error];
    // NSLog(@"matches = %@",matches);
    if([matches count]>0){
        for(SavedArticles * article in matches){
            [context deleteObject:article];
        }
    }
    NSError *saveError = nil;
    [context save:&saveError];

}
@end

