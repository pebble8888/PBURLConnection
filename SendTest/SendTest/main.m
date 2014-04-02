//
//  main.c
//  SendTest
//
//  Created by pebble8888 on 2014/04/02.
//  Copyright (c) 2014年 pebble8888. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "PBURLConnection.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/login"]];
        NSHTTPURLResponse* response;
        NSError* error;
        NSData* data = [PBURLConnection sendSynchronousRequest:request returningResponse:&response error:&error user:@"lorem" pass:@"ipsum"];
        
        NSLog(@"error[%@] response[%ld]", error, response.statusCode);
        NSLog(@"data[%@]", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }
    return 0;
}

