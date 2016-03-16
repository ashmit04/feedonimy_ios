//
//  Feedonimy
//
//  Created by Ashmit Chhabra on 7/24/14.
//  Copyright (c) 2014 ARO. All rights reserved.
//
#import "DatabaseHelper.h"
#import "MyUIManagedDocument.h"

#define DEFAULT_DB_NAME @"RegionPhotosDatabase"

@implementation DatabaseHelper

@synthesize databaseName =_databaseName;
//----------------------------------------------------------------
# pragma mark   -   Accessors
//----------------------------------------------------------------

- (NSFileManager *)fileManager
{
    if (!_fileManager) _fileManager = [[NSFileManager alloc] init];
    return _fileManager;
}

- (UIManagedDocument *)document
{
    if (!_document) {
        NSFileManager *fm = self.fileManager;
        NSURL *baseDir=[[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        _document = [[MyUIManagedDocument alloc] initWithFileURL:
                     [baseDir URLByAppendingPathComponent:self.databaseName]];
        
       // NSLog(@"Core Data: %@ ,%@",[baseDir URLByAppendingPathComponent:self.databaseName],[MyUIManagedDocument persistentStoreName]);
    }
    return _document;
}

-(void)setDatabaseName:(NSString *)databaseName
{
    if (_databaseName != databaseName) {
        _databaseName = databaseName;
        self.document =nil;
    }
    
}
- (NSString *)databaseName
{
    if (!_databaseName) {
        _databaseName = DEFAULT_DB_NAME;
    }
    return _databaseName;
}


+ (DatabaseHelper *)sharedManagedDocument
{
    //----- It's a singleton --------------------------------------------
    static dispatch_once_t pred = 0;
    __strong static DatabaseHelper *_sharedManagedDocument = nil;
    dispatch_once(&pred, ^{
        _sharedManagedDocument = [[self alloc] init];
    });
    return _sharedManagedDocument;
}

//----------------------------------------------------------------
# pragma mark   -   DBHelper methods
//----------------------------------------------------------------

- (void)openDBUsingBlock:(void (^)(BOOL success))block
{
    DatabaseHelper *dbh = [DatabaseHelper sharedManagedDocument];
    if (![dbh.fileManager fileExistsAtPath:[dbh.document.fileURL path]]) {
        [dbh.document saveToURL:dbh.document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:block];
    } else if (dbh.document.documentState == UIDocumentStateClosed) {
        [dbh.document openWithCompletionHandler:block];
    } else {
        BOOL success = YES;
        block(success);
    }
}

- (void)performWithDocument:(OnDocumentReady)onDocumentReady
{
    void (^OnDocumentDidLoad)(BOOL) =^(BOOL success) {
        onDocumentReady(self.document);    };
    if (![self.fileManager fileExistsAtPath:[self.document.fileURL path]]){
        [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForCreating  completionHandler:OnDocumentDidLoad];
    } else if (self.document.documentState == UIDocumentStateClosed) {
        [self.document openWithCompletionHandler:OnDocumentDidLoad];
    } else if (self.document.documentState == UIDocumentStateNormal) {
        OnDocumentDidLoad(YES);
    }
}


@end
