function [ mResFiles, iTCount ] = DeepTravel( strPath, mFiles, iTotalCount )  
    iTmpCount = iTotalCount;  
    path=strPath;  
    Files = dir(fullfile( path,'*.*'));  
    LengthFiles = length(Files);  
    if LengthFiles <= 2  
        mResFiles = mFiles;  
        iTCount = iTmpCount;  
        return;  
    end  
  
  
    for iCount=2:LengthFiles  
        if Files(iCount).isdir==1    
            if Files(iCount).name ~='.'    
                filePath = [strPath  Files(iCount).name '/'];    
                [mFiles, iTmpCount] = DeepTravel( filePath, mFiles, iTmpCount);  
            end    
        else    
            iTmpCount = iTmpCount + 1;  
            filePath = [strPath  Files(iCount).name];   
            mFiles{iTmpCount} = filePath;  
        end   
    end  
    mResFiles = mFiles;  
    iTCount = iTmpCount;  
end  