//
//  PBURLConnection.m
//
//  Copyright (c) 2014 pebble8888. All rights reserved.
//

#import "PBURLConnection.h"

@interface PBURLConnection ()
<NSURLConnectionDelegate
,NSURLConnectionDataDelegate>
@property (nonatomic,strong) NSURLConnection* connection;
@property (nonatomic,strong) NSURLResponse* response;
@property (nonatomic,strong) NSMutableData* receivedata;
@property (nonatomic,strong) NSError* error;
@property (nonatomic,strong) NSString* user;
@property (nonatomic,strong) NSString* pass;
@property (atomic,assign) BOOL complete;
@end

@implementation PBURLConnection

- (id)init
{
    self = [super init];
    if( self ){
        _complete = NO;
    }
    return self;
}

- (void)dealloc
{
    self.connection = nil;
    self.response = nil;
    self.receivedata = nil;
    self.error = nil;
    self.user = nil;
    self.pass = nil;
    [super dealloc];
}

+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request
                 returningResponse:(NSURLResponse **)response
                             error:(NSError **)error
                              user:(NSString *)user
                              pass:(NSString *)pass
{
    PBURLConnection* pbconnection = [[[[self class] alloc] init] autorelease];
    pbconnection.user = user;
    pbconnection.pass = pass;
    pbconnection.connection = [[[NSURLConnection alloc] initWithRequest:request
                                                               delegate:pbconnection
                                                       startImmediately:YES] autorelease];
    while( !pbconnection.complete ){
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
    if( response != nil ){
        *response = [[pbconnection.response copy] autorelease];
    }
    if( error != nil ){
        *error = [[pbconnection.error copy] autorelease];
    }
    return pbconnection.receivedata;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.error = error;
    self.complete = YES;
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return YES;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if( [challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic] ){
        if( challenge.previousFailureCount > 0 ){
            [challenge.sender cancelAuthenticationChallenge:challenge];
        } else {
            NSURLCredential* cred = [NSURLCredential credentialWithUser:self.user
                                                               password:self.pass
                                                            persistence:NSURLCredentialPersistenceNone];
            [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
        }
    }
    else if( [challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust] ){
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
    else {
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.response = response;
    self.receivedata = [[[NSMutableData alloc] init] autorelease];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedata appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.complete = YES;
}

@end
