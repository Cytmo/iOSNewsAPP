#import <Foundation/Foundation.h>

@interface NewsDataItem : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *brief;
@property (nonatomic,strong) NSString *imgURL;
@property (nonatomic,strong) NSString *newsURL;
@end