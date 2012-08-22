#import <Foundation/Foundation.h>


@interface StringUtil : NSObject {

}

/**
 * This method concatenates two strings and returns the result.
 */
+(NSString*)concat:(NSString*)firstString withString:(NSString*)secondString;

/**
* This method concatenates multiple strings and returns the result.
*/
+(NSString*)concatenate:(NSString*)firstString withString:(NSString*)secondString, ...;

@end
