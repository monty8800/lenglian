//
//  UIImageView+XE.m
//  HelloCordova
//
//  Created by ywen on 15/10/9.
//
//

#import "UIImageView+XE.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Global.h"

@implementation UIImageView (XE)

-(void)XE_setImage:(NSString *)url size:(ImageSize)size type:(ImageType)type {
    if ([url isKindOfClass:[NSString class]] && url.length > 5) {
        NSMutableString *fullPath;
        if ([url hasPrefix:@"http://"] || [url hasPrefix:@"file://"]) {
            fullPath = [[NSMutableString alloc] initWithString: url];
        }
        else
        {
            fullPath = [[NSMutableString alloc] initWithString: IMG_SERVER];
            NSArray *paths = [url componentsSeparatedByString:@"|"];
            if (paths.count > 1) {
                [fullPath appendFormat:@"/%@/", paths[1]];
            }
            switch (size) {
                case s250x250:
                    [fullPath appendString:@"/250/250/"];
                    break;
                    
                case s200x200:
                    [fullPath appendString:@"/200/200/"];
                    break;
                    
                case s130x130:
                    [fullPath appendString:@"/130/130/"];
                    break;
                    
                case s100x100:
                    [fullPath appendString:@"/100/100/"];
                    break;
                    
                case s80x80:
                    [fullPath appendString:@"/80/80/"];
                    break;
                    
                case s60x60:
                    [fullPath appendString:@"/60/60/"];
                    break;
                    
                default:
                    break;
            }
            
            
            [fullPath appendString:paths[0]];
            
            UIImage *img = [UIImage imageNamed:type == Avatar ? @"avatar" : @"default"];
            
            [self sd_setImageWithURL:[NSURL URLWithString: fullPath] placeholderImage:img];
        }
    }
    else
    {
        if (type == Avatar) {
            self.image = [UIImage imageNamed:@"avatar"];
        }
        else
        {
            self.image = [UIImage imageNamed:@"default"];
        }
        
    }
}

@end
