//
//
//  Feedonimy
//
//  Created by Ashmit Chhabra on 7/24/14.
//  Copyright (c) 2014 ARO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^OnDocumentReady) (UIManagedDocument *document);

@interface DatabaseHelper : NSObject

@property (nonatomic, strong) NSString *databaseName;
@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, strong) NSFileManager *fileManager;

+ (DatabaseHelper *)sharedManagedDocument;
- (void)openDBUsingBlock:(void (^)(BOOL success))block;
- (void)performWithDocument:(OnDocumentReady)onDocumentReady;
@end
