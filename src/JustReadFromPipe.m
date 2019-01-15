function JustReadFromPipe( filename )
error(nargchk(1,1,nargin));

%% Open file
f = fopen(filename,'rb');
if (f < 0)
    error('Couldn''t open file %s',filename);
    return;
end

%% Process all entries in file
while 1
    field_len = fread(f, 1, 'uint16', 0, 'ieee-be');
    code = fread(f,1);

    if (code == 187)
        bytes = fread(f, field_len-1, 'uint8=>uint8');
        if(length(bytes) ~= field_len-1)
            fclose(f);
            return;
        end
    else %skip all other info
        fread(f,field_len-1);
        continue;
    end

end

end

