#import "StringUtil.h"


@implementation StringUtil

/**
 * This method concatenates two strings and returns the result.
 */
+ (NSString*)concat:(NSString*)firstString withString:(NSString*)secondString {
	return [NSString stringWithFormat:@"%@%@", firstString, secondString];
}


/**
 * This method concatenates multiple strings and returns the result.
 */
+ (NSString*)concatenate:(NSString*)firstString withString:(NSString*)secondString, ... {
	NSString* newString = [StringUtil concat:firstString withString:secondString];
	NSString* currentString;

	va_list stringList;
	
	va_start(stringList, secondString);
	while ((currentString = va_arg(stringList, NSString*))) {
		newString = [StringUtil concat:newString withString:currentString];
	}
	va_end(stringList);
	
	return newString;
}

@end
