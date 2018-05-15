//
//  Favorite+Extension.m
//  TubeOnRoad
//
//  Created by Karthik Rajasekaran on 11/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Favorite+Extension.h"

@implementation Favorite (Extension)



+ (BOOL) existsWithVideoId:(NSString *) videoID inManagedObjectContext:(NSManagedObjectContext *) managedObjectContext
{
    NSUInteger fetchCount;
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Favorite"];
    NSPredicate *criteria = [NSPredicate predicateWithFormat:@"videoInfo.videoID == %@",videoID];
    
    [fetchRequest setFetchLimit:1];
    
    [fetchRequest setPredicate:criteria];
    fetchCount = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
    
    if (error)
        NSLog(@"Favorite.existsWithVideoId exception in countForFetchRequest:%@",[error localizedDescription]);
    
    return (fetchCount == 1?YES:NO);
}

+ (NSArray *) listOfVideoIdsWithContext:(NSManagedObjectContext *) managedObjectContext
{
 // TBD : This is presently extremely in-efficient code... Need to enhance so that this method only fetches videoIds and returns the list instead of the whole kit and kaboodle on favorites   
    NSError *error;
    NSArray *listofVideoIds;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Favorite"];

//    NSPropertyDescription *propDescriptor = [[NSPropertyDescription alloc] init];
 //   [propDescriptor setName:@"videoInfo"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
  //  [fetchRequest setResultType:NSDictionaryResultType];
  //  [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:propDescriptor]];
    NSLog(@"before the fetch execute...");
    listofVideoIds = [managedObjectContext executeFetchRequest:fetchRequest error:&error];    
    if (error)
        NSLog(@"Favorite.listOfVideoIdsWithContext exception in countForFetchRequest:%@",[error localizedDescription]);
    NSLog(@"count of fetch:%d",[listofVideoIds count]);
    return listofVideoIds;
    
}

@end
