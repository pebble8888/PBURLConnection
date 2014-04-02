//
//  PBURLConnection.h
//
//  Copyright (c) 2014 pebble8888. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBURLConnection : NSObject
+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)errorr user:(NSString *)user pass:(NSString *)pass;
@end
