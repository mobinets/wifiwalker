function madvalue = MAD( Y,w,j,flag )
if strcmp(flag,'before')==1
    Ymean=mean(Y(j-w:j));
    sum=0;
    for i=j-w:j
        sum=sum+abs(Y(i)-Ymean);
    end
    madvalue=sum/w;
else
    if strcmp(flag,'after')==1
     
    Ymean=mean(Y(j:j+w));
    sum=0;
    for i=j:j+w
        sum=sum+abs(Y(i)-Ymean);
    end
    madvalue=sum/w; 
    else
        madvalue=-1;
    end
end

end

