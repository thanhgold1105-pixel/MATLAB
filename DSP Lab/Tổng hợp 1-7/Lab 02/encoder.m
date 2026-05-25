function bits = encoder(i)

    bits = strings(length(i),1);

    for k = 1:length(i)
        switch i(k)
            case 0
                bits(k) = "100";   % -4Δ
            case 1
                bits(k) = "111";   % -3Δ
            case 2
                bits(k) = "110";   % -2Δ
            case 3
                bits(k) = "101";   % -1Δ
            case 4
                bits(k) = "000";   % 0
            case 5
                bits(k) = "001";   % 1Δ
            case 6
                bits(k) = "010";   % 2Δ
            case 7
                bits(k) = "011";   % 3Δ
            otherwise
                bits(k) = "ERR";
        end
    end

end