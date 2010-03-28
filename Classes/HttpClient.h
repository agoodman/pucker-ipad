//
//  HttpClient.h
//  PuckerLite
//
//  Created by Aubrey Goodman on 5/28/09.
//  Copyright 2009 Migrant Studios LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>


@interface HttpClient : NSObject {

}

+(HttpClient*)sharedInstance;
+(NSString*)urlEncode:(NSString*)string;

-(NSString*)stringGetURL:(NSURL*)url;
-(NSString*)stringPostURL:(NSURL*)url content:(NSData*)content;
-(NSString*)synchronousRequest:(NSURLRequest*)req;
- (BOOL)isReachableWithoutRequiringConnection:(SCNetworkReachabilityFlags)flags;
- (BOOL)isHostReachable:(NSString *)host;


@end
