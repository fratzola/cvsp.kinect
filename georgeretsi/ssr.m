function R = ssr(I, scale, weight)
%RETINEX enhance the image
%I = double(imread(filename)) + 1;

[width, height] = size(I);

FInverse = 0;
for i = 1 : width
for j = 1 : height
%Fk(i, j) = exp(-((i-width/2).^2 + (j-height/2).^2)/scale.^2);
Fk(i,j) = exp((-i.^2 - j.^2)/scale.^2);
FInverse = FInverse + Fk(i,j);
end
end

coff = 1 / FInverse;
Fk = Fk * coff;

Ift = zeros(size(I));

Ift = fft2(I);
Fkft = fft2(Fk);

tmpSumft = Ift.* Fkft;
tmpSum = ifft2(abs(tmpSumft));

R = weight * (log(I) - log(abs(tmpSum)));

%figure(2);
%subplot(2, 1, 1);
%imshow(uint8(I));
%subplot(2, 1, 2);
%maxp = max(R(:));
%minp = min(R(:));
%step = 255/(maxp - minp);
%imshow(uint8((R-minp)*step-1));
