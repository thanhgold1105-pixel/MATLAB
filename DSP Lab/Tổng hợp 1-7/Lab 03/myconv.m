    function y = myconv(x, h)
    
    Lx = length(x);
    Lh = length(h); % độ dài h
    
    Ly = Lx + Lh - 1; % độ dài output
    
    y = zeros(1, Ly); % cộng dồn
    
    for n = 1:Ly % mỗi vòng → tính 1 y(n)
        for k = 1:Lh
            if (n - k + 1 > 0) && (n - k + 1 <= Lx) % chỉ lấy giá trị khi x(n-k+1) hợp lệ
                y(n) = y(n) + h(k) * x(n - k + 1);% x(1) tương ứng x[0]
            end
        end
    end
    
    end