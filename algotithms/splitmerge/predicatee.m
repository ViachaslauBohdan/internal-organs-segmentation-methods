split_predicate = @splitpredicate;
merge_predicate = @mergepredicate

function flag = splitpredicate(region) 
      sd = std2(region); 
      m = mean2(region);
      
      flag = (sd > 0.04);
end

function flag = mergepredicate(region1,region2) 
      sd = std2(region); 
      m = mean2(region) ;
    
      flag = (sd > 0.04);
end

