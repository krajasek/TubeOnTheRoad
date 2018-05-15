//
//  YTjson.m
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 11/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTjson.h"

@implementation YTjson

+ (NSString *) titleFromVideoData:(NSArray *)videoData atIndex:(NSInteger) index {
    
    NSDictionary *searchResultContent;
    
    searchResultContent = [NSDictionary dictionaryWithObject:[videoData objectAtIndex:index] forKey:@"searchResult"];
    
    return [searchResultContent valueForKeyPath:@"searchResult.title.$t"];
    
}


+ (NSString *) uploaderFromVideoData:(NSArray *)videoData atIndex:(NSInteger) index {
    
    NSDictionary *searchResultContent;
    NSString *uploaderName;
    
    searchResultContent = [NSDictionary dictionaryWithObject:[videoData objectAtIndex:index] forKey:@"searchResult"];
    
    
    NSArray *authorContent = [searchResultContent valueForKeyPath:@"searchResult.author"];
    
    if ([authorContent count] > 0) {
        NSDictionary *authorObject = [authorContent objectAtIndex:0];
        uploaderName = [authorObject valueForKeyPath:@"name.$t"];        
        
    }
    else {
        uploaderName = nil;
    }
    
    return uploaderName;
    
}

+ (NSString *) viewCountFromVideoData:(NSArray *)videoData atIndex:(NSInteger) index {
    
    NSDictionary *searchResultContent;
    
    searchResultContent = [NSDictionary dictionaryWithObject:[videoData objectAtIndex:index] forKey:@"searchResult"];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

    NSUInteger viewCount = [[searchResultContent valueForKeyPath:@"searchResult.yt$statistics.viewCount"] integerValue];
    
    NSString *fmtViewCount = [NSString stringWithFormat:@"%@ views",[formatter stringFromNumber:[NSNumber numberWithInteger:viewCount]]];

    return fmtViewCount;
    
}

+ (NSString *) durationFromVideoData:(NSArray *)videoData atIndex:(NSInteger) index {
    
    NSDictionary *searchResultContent;
    NSString *durationStr;
    
    searchResultContent = [NSDictionary dictionaryWithObject:[videoData objectAtIndex:index] forKey:@"searchResult"];
    
    durationStr =  [searchResultContent valueForKeyPath:@"searchResult.media$group.yt$duration.seconds"];
    
    return [self getFormattedDuration:[durationStr integerValue]];
}


+ (NSString *) thumbnailURLFromVideoData:(NSArray *)videoData atIndex:(NSInteger) index {
    
    NSDictionary *searchResultContent;
    NSString *thumbnailurl;
    
    searchResultContent = [NSDictionary dictionaryWithObject:[videoData objectAtIndex:index] forKey:@"searchResult"];
    
    
    NSArray *thumbnailContent = [searchResultContent valueForKeyPath:@"searchResult.media$group.media$thumbnail"];
    
    if ([thumbnailContent count] > 0) {
        NSDictionary *thumbnailObject = [thumbnailContent objectAtIndex:0];
        thumbnailurl = [thumbnailObject valueForKeyPath:@"url"];        
        
    }
    else {
        thumbnailurl = nil;
    }
    
    NSLog(@"thumbnail url:%@",thumbnailurl);
    return thumbnailurl;
    
}

+ (NSString *) videoIDFromVideoData:(NSArray *)videoData atIndex:(NSInteger) index {
    
    NSDictionary *searchResultContent;
    
    searchResultContent = [NSDictionary dictionaryWithObject:[videoData objectAtIndex:index] forKey:@"searchResult"];
    
    return [searchResultContent valueForKeyPath:@"searchResult.media$group.yt$videoid.$t"];
    
}

+ (NSString *) getFormattedDuration:(NSInteger) durationInSeconds
{

    
    NSInteger hours, minutes, minutesa, seconds;
    NSString *minuteStr, *secondsStr;
    
    if (durationInSeconds < 60) { //only seconds
        hours = 0;
        minutes = 0;
        seconds = durationInSeconds;
    }
    else if (durationInSeconds >=60 && durationInSeconds <3600) {
        hours = 0;
        minutes = durationInSeconds/60;
        seconds = durationInSeconds % 60;
    }
    else {
        hours = durationInSeconds/(60*60);
        minutesa = durationInSeconds % (60*60);
        minutes = minutesa /60;
        seconds = minutesa % 60;
    }

    if (minutes < 10 )
        minuteStr = [NSString stringWithFormat:@"0%d",minutes];
    else {
        minuteStr = [NSString stringWithFormat:@"%d", minutes];
    }

    if (seconds < 10 )
        secondsStr = [NSString stringWithFormat:@"0%d",seconds];
    else {
        secondsStr = [NSString stringWithFormat:@"%d", seconds];
    }

    return (hours > 0 ? [NSString stringWithFormat:@"%d:%@:%0@",hours,minuteStr,secondsStr]:[NSString stringWithFormat:@"%@:%@",minuteStr,secondsStr]);
}   


@end
