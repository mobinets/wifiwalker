function y=CMR(x)
 a=mean(x);
 y=0;
 [m,n]=size(x);
 for i=1:1:m
     if x(i,1)>=a
         y=y+1;
     end
 end
 y=y/m;
end