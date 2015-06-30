arr = {};

function getTable( req )
    if (  arr[ req ] ) then
        return arr[ req ];
    end

    return false;
end