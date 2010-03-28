//
//  HttpClient.m
//  PuckerLite
//
//  Created by Aubrey Goodman on 5/28/09.
//  Copyright 2009 Migrant Studios LLC. All rights reserved.
//

#import "HttpClient.h"


static HttpClient *instance;

@implementation HttpClient

+ (HttpClient*)sharedInstance
{
	if( instance==nil ) {
		instance = [[HttpClient alloc] retain];
	}
	return instance;
}

+ (NSString*)urlEncode:(NSString*)string
{
	NSString *result = (NSString *) 
		CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
												(CFStringRef)string, 
												NULL, 
												CFSTR("?=&+"), 
												kCFStringEncodingUTF8);
	return result;
}

- (NSString *)stringGetURL:(NSURL *)url
{
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
												cachePolicy:NSURLRequestReturnCacheDataElseLoad
											timeoutInterval:10];
	return [self synchronousRequest:urlRequest];
}

- (NSString*)stringPostURL:(NSURL*)url content:(NSData*)content
{
	NSString *contentLength = [NSString stringWithFormat:@"%d",[content length]];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:contentLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:content];
	
	return [self synchronousRequest:request];
}

- (NSString*)synchronousRequest:(NSURLRequest*)req
{
	// Fetch the JSON response
	NSData *urlData;
	NSURLResponse *rsp;
	NSError *error;
	
	// Make synchronous request
	urlData = [NSURLConnection sendSynchronousRequest:req
									returningResponse:&rsp
												error:&error];
	
 	// Construct a String around the Data from the response
	return [[[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding] autorelease];
}

- (BOOL)isReachableWithoutRequiringConnection:(SCNetworkReachabilityFlags)flags
{
    // kSCNetworkReachabilityFlagsReachable indicates that the specified nodename or address can
    // be reached using the current network configuration.
    BOOL isReachable = flags & kSCNetworkReachabilityFlagsReachable;
    
    // This flag indicates that the specified nodename or address can
    // be reached using the current network configuration, but a
    // connection must first be established.
    //
    // If the flag is false, we don't have a connection. But because CFNetwork
    // automatically attempts to bring up a WWAN connection, if the WWAN reachability
    // flag is present, a connection is not required.
    BOOL noConnectionRequired = !(flags & kSCNetworkReachabilityFlagsConnectionRequired);
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
        noConnectionRequired = YES;
    }
    
    return (isReachable && noConnectionRequired) ? YES : NO;
}

// Returns whether or not the current host name is reachable with the current network configuration.
- (BOOL)isHostReachable:(NSString *)host
{
    if (!host || ![host length]) {
        return NO;
    }
    
    SCNetworkReachabilityFlags        flags;
    SCNetworkReachabilityRef reachability =  SCNetworkReachabilityCreateWithName(NULL, [host UTF8String]);
    BOOL gotFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    
    CFRelease(reachability);
    
    if (!gotFlags) {
        return NO;
    }
    
    return [self isReachableWithoutRequiringConnection:flags];
}

@end
