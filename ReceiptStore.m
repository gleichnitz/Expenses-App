//
//  ReceiptStore.m
//  Finance
//
//  Created by Gabriela Leichnitz on 7/16/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import "ReceiptStore.h"

@interface ReceiptStore ()
{
    NSMutableDictionary *_dictionary;
}
- (NSString *)imagePathForKey:(NSString *)key;

@end

@implementation ReceiptStore

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:key];
}

- (void)setImage:(UIImage *)i forKey:(NSString *)s
{
    [_dictionary setObject:i
                    forKey:s];
    
    NSString *imagePath = [self imagePathForKey:s];
    NSData *d = UIImageJPEGRepresentation(i, 0.5);
    [d writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)s
{
    UIImage *result = [_dictionary objectForKey:s];
    
    if (!result) {
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
        
        if (result) {
            [_dictionary setObject:result
                            forKey:s];
        } else {
            NSLog(@"Error: unable to find %@", [self imagePathForKey:s]);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)s
{
    if (!s) {
        return;
    }
    [_dictionary removeObjectForKey:s];
    [[NSFileManager defaultManager] removeItemAtPath:s
                                               error:nil];
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (ReceiptStore *)sharedStore
{
    static ReceiptStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:NULL] init];
    }
    return sharedStore;
}

- (void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %d images out of the cache", [_dictionary count]);
    [_dictionary removeAllObjects];
}

- (id) init
{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    return self;
}


@end
