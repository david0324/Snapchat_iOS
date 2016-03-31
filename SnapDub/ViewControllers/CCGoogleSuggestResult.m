#import "CCGoogleSuggestResult.h"

static NSString *const GoogleSearchURL = @"http://www.google.com/search?q=";

@implementation CCGoogleSuggestResult

- (id) initWithQuery: (NSString*) query
{
    self = [super init];
    if (query) {
        _query = query;
        return self;
    } else {
        return nil;
    }
}

+ (id) resultWithQuery: (NSString*) query
{
    return [[self alloc] initWithQuery:query];
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"<%@ 0x%p: %@", [self class], self, _query];
}

@end
