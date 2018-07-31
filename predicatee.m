a = @predicate;

function flag = predicate(region) 
      sd = std2(region); 
      m = mean2(region) ;
      max(region);
      flag = (max(region(:))-min(region(:))) > 0.2;
end