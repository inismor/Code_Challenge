/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "NSObject-Description.h"
#import "NametagUtilities.h"

@implementation NSObject (DebuggingExtensions)
// Return 'Class description : hex memory address'
- (NSString *) objectIdentifier
{
    return [NSString stringWithFormat:@"%@:0x%0x", self.class.description, (int) self];
}

// Nametag or identifier, based on availability
- (NSString *) objectName
{
    if (self.nametag)
        return [NSString stringWithFormat:@"%@:0x%0x", self.nametag, (int) self];
    return [NSString stringWithFormat:@"%@", self.objectIdentifier];
}

NSString *consoleString(NSString *string, NSInteger maxLength, NSInteger indent)
{
    // Build spacer
    NSMutableString *spacer = [NSMutableString stringWithString:@"\n"];
    for (int i = 0; i < indent; i++)
        [spacer appendString:@" "];    
    
    // Decompose into space-separated items
    NSArray *wordArray = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSInteger wordCount = wordArray.count;
    NSInteger index = 0;
    NSInteger lengthOfNextWord = 0;
    
    // Perform decomposition
    NSMutableArray *array = [NSMutableArray array];
    while (index < wordCount)
    {
        NSMutableString *line = [NSMutableString string];
        while (((line.length + lengthOfNextWord + 1) <= maxLength) &&
               (index < wordCount))
        {
            lengthOfNextWord = [wordArray[index] length];
            [line appendString:wordArray[index]];
            if (++index < wordCount)
                [line appendString:@" "];
        }
		///RWW⬇︎⬇︎⬇︎⬇︎⬇︎
		if ( line.length > 0 ) {
		///RWW⬆︎⬆︎⬆︎⬆︎⬆︎
        [array addObject:line];
		///RWW⬇︎⬇︎⬇︎⬇︎⬇︎
		} else {
			++index;
		}
		///RWW⬆︎⬆︎⬆︎⬆︎⬆︎
    }
    
    return [array componentsJoinedByString:spacer];
}

// Wrapped description
- (NSString *) consoleDescription
{
    return consoleString(self.description, 80, 8);
}
@end

