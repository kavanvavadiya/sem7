function filtered_I = mean_shift_filter(I,sig_s,sig_r)
    [r, c] = size(I);
    BWby2 = ceil(3*sig_s)+1;
    e = 0.01;
    filtered_I = zeros(size(I));
    
    for x = 1:c
        for y = 1:r
            f = [x y I(y,x)];
            
            while true
                i1 = max(y-BWby2,1); 
                i2 = min(y+BWby2,r); 
                j1 = max(x-BWby2,1); 
                j2 = min(x+BWby2,c); 
                LI = I(i1:i2,j1:j2);
                
                [X, Y] = meshgrid(j1:j2,i1:i2);
                Gs = exp(-1*((X-f(1)).^2 + (Y-f(2)).^2) / (2*sig_s^2));
                Gr = exp(-1*((LI-f(3)).^2) / (2*sig_r^2));
                G = Gs .* Gr;
                
                Wp = sum(G, 'all');
                fx = sum(G.*X, 'all') / Wp;
                fy = sum(G.*Y, 'all') / Wp;
                fI = sum(G.*LI, 'all') / Wp;
                
                if norm(f - [fx fy fI]) > e
                    f = [fx fy fI];
                else
                    break;
                end
            end
            
            filtered_I(y, x) = f(3);
        end
    end
end
