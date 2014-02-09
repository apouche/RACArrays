About
===

This simple project demonstrates how to use [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) to check for NSArray size changes.

It was inspired from [this](http://stackoverflow.com/questions/18786226/reactivecocoa-example-with-nsmutablearray-push-pop) question on stack overflow.

Code
===

Basically it all comes down to this part
```
// this will give us old and new value for the mutableArray propery when it changes
    RACSignal* signal = [self rac_valuesAndChangesForKeyPath:@keypath(self,mutableArray)
                                                     options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                                                    observer:self];
    
    [signal subscribeNext:^(RACTuple* tuple) {
        // the changes dictionary is stored in the second propery of the RAC Tuple
        NSDictionary* changes = tuple.second;
        
        NSArray* oldArray = changes[NSKeyValueChangeOldKey];
        NSArray* newArray = changes[NSKeyValueChangeNewKey];
        NSIndexPath* indexpath = nil;
        
        [self.tableview beginUpdates];
        
        // this all comes down to this comparision, here the update is animated but need not to be.
        if (newArray.count > oldArray.count) {
            indexpath = [NSIndexPath indexPathForRow:newArray.count-1 inSection:0];
            [self.tableview insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else if (newArray.count < oldArray.count) {
            indexpath = [NSIndexPath indexPathForRow:oldArray.count-1 inSection:0];
            [self.tableview deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        [self.tableview endUpdates];
    }];
```

