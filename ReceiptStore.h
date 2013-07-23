//
//  ReceiptStore.h
//  Finance
//
//  Created by Gabriela Leichnitz on 7/16/13.
//  Copyright (c) 2013 Gabriela Leichnitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiptStore : NSObject

+ (ReceiptStore *)sharedStore;

- (void)setImage:(UIImage *)i forKey:(NSString *)s;
- (UIImage *)imageForKey:(NSString *)s;
- (void)deleteImageForKey:(NSString *)s;

@end
