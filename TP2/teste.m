conf = zeros(100, 1);
data2 = [training; testing];
for i=1:100,
    for j=1:100,
        if sum(data(i,:) == data2(j,:)) == 3,
            conf(j) = 1;
            break;
        end;            
    end;
end;