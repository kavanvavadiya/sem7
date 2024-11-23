function denoised = mybilateralfilter(I, sig_s, sig_r)
kernel=11;
f= floor(kernel/2);
c = ceil(kernel/2);
denoised = zeros(size(I));
padded = padarray(I, [f, f], 0, "both");
[X, Y] = meshgrid(1-c:kernel-c,1-c:kernel-c );
norm = X.^2+Y.^2;
gauss_s = exp(-norm/(2*pi*(sig_s^2)))/(2*pi*sig_s);
for i=1:size(I,1)
    for j=1:size(I,2)
        submatrix = padded(i:i+kernel-1, j:j+kernel-1);
        sub_diff = abs(submatrix-submatrix(c,c));
        gauss_r = exp(-(sub_diff.^2)/(2*pi*(sig_r^2)))/(2*pi*sig_r);
        final = gauss_s.*gauss_r.*submatrix;
        normalizer=gauss_s.*gauss_r;
        denoised(i, j) = sum(final(:))/sum(normalizer(:));
    end
end
end