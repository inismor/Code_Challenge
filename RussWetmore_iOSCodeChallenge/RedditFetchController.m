//
//  RedditFetchController.m
//  
//
//  Created by Russ Wetmore on 7/27/15.
//
//

@import AFNetworking;

#import "RedditFetchController.h"


NSUInteger const kNumberOfStoredFields = 6u;
NSString * const kInitialSearchTerm = @"funny";
NSString * const kFetchPath = @"http://www.reddit.com/r/XXX/.json";
NSString * const START_FETCH_NOTIFICATION = @"StartFetchNotification";


@interface RedditFetchController ()

@end


@implementation RedditFetchController

#pragma mark - Object Lifecycle

- (instancetype) initWithDelegate:(id<RedditFetchControllerDelegate>)delegate
{
	if (( self = [super init] )) {
		_delegate = delegate;
		_searchTerm = kInitialSearchTerm;
//		_posts = [NSMutableArray array];
		
		// When initialized, kick off a fetch using the initial search term
		[self fetch];
	}
	
	return self;
}


#pragma mark - Utility

- (BOOL) delegateConforms:(SEL)selector {
	return [self.delegate conformsToProtocol:@protocol(RedditFetchControllerDelegate)]  &&
		[self.delegate respondsToSelector:selector];
}


#pragma mark - Controller Control

- (void) startFetchWithSearchTerm:(NSString *)searchTerm
{
	[self setSearchTerm:searchTerm];
	[self start];
}

- (void) start
{
	BOOL shouldStart = YES;
	if ( [self delegateConforms:@selector(fetchController:shouldStartFetchWithSearchTerm:)] ) {
		shouldStart = [self.delegate fetchController:self shouldStartFetchWithSearchTerm:self.searchTerm];
	}
	
	if ( ! shouldStart ) {
		return;
	}
	
	[self fetch];
	
	if ( [self delegateConforms:@selector(fetchControllerDidStartFetch:)] ) {
		[self.delegate fetchControllerDidStartFetch:self];
	}
}

- (void) cancel
{
	// FIXME: nothing yet
}


#pragma mark - Web Endpoint Communication

- (void) fetch
{
	// Insert the search term into the endpoint URL
	NSString *fetchPath = [kFetchPath stringByReplacingOccurrencesOfString:@"XXX"
																withString:self.searchTerm];
	// Set up AFNetworking
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	// Initiate the fetch, no parameters
	//	On success: parse the returned json into a lighter weight dictionary and save the result
	//	On failure: alert the delegate
	[manager GET:fetchPath
	  parameters:nil
		 success:^(AFHTTPRequestOperation *operation, id responseObject) {
			 
			 // Reach into the children array
			 NSArray *posts = [(NSDictionary *)responseObject valueForKeyPath:@"data.children"];

			 // Initialize the saved posts array
			 NSMutableArray *newPosts = [NSMutableArray arrayWithCapacity:posts.count];
			 
			 // For each element in the array, pull out the data we want to keep and save
			 for (NSDictionary *post in posts) {
				 NSMutableDictionary *aPost = [[NSMutableDictionary alloc] initWithCapacity:kNumberOfStoredFields];
				 NSDictionary *data = post[@"data"];
				 
				 // Stringz iz EZ
				 [aPost setObject:data[@"title"]		forKey:@"title"];
				 [aPost setObject:data[@"author"]		forKey:@"author"];
				 [aPost setObject:data[@"thumbnail"]	forKey:@"thumbnail"];
				 
				 // Numberz not so much
				 [aPost setObject:[data[@"num_comments"] stringValue]	forKey:@"numComments"];
				 [aPost setObject:[data[@"ups"] stringValue]			forKey:@"ups"];
				 [aPost setObject:[data[@"downs"] stringValue]			forKey:@"downs"];
				 
				 [newPosts addObject:[NSDictionary dictionaryWithDictionary:aPost]];
			 }
			 
			 // Save the final result away
			 [self setPosts:newPosts];
			 
			 // If the delegate exists and implements it, alert it that we're finished
			 if ( [self delegateConforms:@selector(fetchControllerDidEndFetch:)] ) {
				 [self.delegate fetchControllerDidEndFetch:self];
			 }

//			 NSLog(@"JSON: %@", self.posts);
		 }
		 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			 // ALert the delegate that we failed
			 if ( [self delegateConforms:@selector(fetchControllerDidFailFetchWithError:error:)] ) {
				 [self.delegate fetchControllerDidFailFetchWithError:self error:error];
			 }
			 
			 // reset results
			 [self setPosts:[NSMutableArray array]];
			 
			 NSLog(@"Error: %@", error);
		 }];
}

@end
