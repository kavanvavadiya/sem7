function BF = mybilateralfilter(I, sigs, sigr)
    [r, c] = size(I);
    BF = zeros(r, c);
    BWby2 = ceil(3 * sigs);
    
    [X, Y] = meshgrid(-BWby2:BWby2, -BWby2:BWby2);
    Gs = exp(-(X.^2 + Y.^2) / (2 * sigs^2));
    
    for x = 1:c
        for y = 1:r
            i1 = max(y - BWby2, 1);
            i2 = min(y + BWby2, r);
            j1 = max(x - BWby2, 1);
            j2 = min(x + BWby2, c);
            
            LI = I(i1:i2, j1:j2);
            [local_r, local_c] = size(LI);
            
            local_X = X(1:local_r, 1:local_c) + (j1 - x);
            local_Y = Y(1:local_r, 1:local_c) + (i1 - y);
            Gr = exp(-((LI - I(y, x)).^2) / (2 * sigr^2));
            
            Gs_local = Gs(1:local_r, 1:local_c);
            numerator = sum(Gs_local .* Gr .* LI, 'all');
            denominator = sum(Gs_local .* Gr, 'all');
            BF(y, x) = numerator / denominator;
        end
    end
end
