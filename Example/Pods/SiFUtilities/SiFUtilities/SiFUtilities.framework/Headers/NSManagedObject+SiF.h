//
//  NSManagedObject+SiF.h
//  SiFUtilities
//
//  Created by Nguyen Chi Cong on 6/10/16.
//  Copyright © 2016 [iF] Solution. All rights reserved.
//

@import CoreData;

@interface NSManagedObject (SiF)

- (void)updateAttributesWithInfo: (id)info relationshipTransformers: (NSDictionary *)transformers;
- (void)updateAttributesWithInfo: (id)info ignoreKeys: (NSArray *)ignoreKeys relationshipTransformers: (NSDictionary *)transformers;

@end
