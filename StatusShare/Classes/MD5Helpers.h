//
//  MD5Helpers.h
//
// Code copied from StackOverflow http://stackoverflow.com/questions/1524604/md5-algorithm-in-objective-c

#import <Foundation/Foundation.h>

@interface NSString (MD5Helpers)
- (NSString *) md5;
@end

@interface NSData (MD5Helpers)
- (NSString*)md5;
@end