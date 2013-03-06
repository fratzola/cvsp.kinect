function [H,cell_hists]=HOG(Im,B,cells,blocks,overlap,signed,gauss_filt,distr)
% find hog descriptors of an image
% B number of bins
%
%angle range 0: 0-pi , 1:-pi:pi

[N,M]=size(Im); 

cells_i = cells(1);
cells_j = cells(2);
blocks_i = blocks(1);
blocks_j = blocks(2);

% derivative
hx = [-1,0,1];
hy = -hx';
grad_x = imfilter(Im,hx);
grad_y = imfilter(Im,hy);

% angle and magnitude
angle=atan2(grad_y,grad_x);
magn=((grad_y.^2)+(grad_x.^2)).^.5;

% indexed array of angles for quicker calculations
bins = B;
neg_idx = find(angle<0);
if (signed == 0)   
    angle(neg_idx) = pi+angle(neg_idx);   
else
    angle(neg_idx) = 2*pi+angle(neg_idx);
    bins = B/2;
end
p = pi/bins+.000001;
ind_angle = 1+ angle/p;

% gaussian variance for fair share bins
s = 1/6;

cell_size_i = floor(N/cells_i);
cell_size_j = floor(M/cells_j);

cell_hists = zeros(cells_i,cells_j,B);
%cont=0;
for i=1:cells_i
    for j=1:cells_j      
       
        m_part = magn((i-1)*cell_size_i+1:i*cell_size_i,(j-1)*cell_size_j+1:j*cell_size_j);
        a_part = ind_angle((i-1)*cell_size_i+1:i*cell_size_i,(j-1)*cell_size_j+1:j*cell_size_j); 
        mm = m_part(:);
        aa = a_part(:);
    
        % histogram of each block
        K = length(mm);
        hist = zeros(B,1);
        for k = 1:K
            a_i = floor(aa(k)); 
            if (distr == 1)
                diff = abs(a_i-aa(k))-.5;
                neighb_part = round(100*(0.5-erf((.5-abs(diff))/(s*sqrt(2)))/2))/100;
                if (diff > 0)
                    if (a_i == bins) a_i_n = 1;
                    else a_i_n = a_i+1;
                    end
                else
                    if (a_i == 1) a_i_n = bins;
                    else a_i_n = a_i-1;
                    end
                end
                hist(a_i_n) = hist(a_i_n) + neighb_part*mm(k);
                hist(a_i) = hist(a_i) + (1-neighb_part)*mm(k);
            else
                hist(a_i) = hist(a_i) + mm(k);
            end
        end;  
        cell_hists(i,j,:) = hist;
        
        %cont = cont+1;
        %hist=hist/(norm(hist)+0.0001);
        %H((cont-1)*B+1:cont*B,1)=hist;
    end
end

% block grid from cell grid
if overlap == 0
    block_size_i = floor(cells_i/blocks_i);
    block_size_j = floor(cells_j/blocks_j);
else
    block_size_i = floor(2*cells_i/(blocks_i+1));
    block_size_j = floor(2*cells_j/(blocks_j+1));
end

if (gauss_filt > 0)
    g = fspecial('gaussian',[block_size_i block_size_j],gauss_filt);
    g = g/max(max(g));
end

cont=0;
for i = 1:blocks_i
    for j = 1:blocks_j
        
        if overlap == 0
            start_i = 1+ (i-1)*block_size_i;
            end_i = start_i+block_size_i-1;
            start_j = 1+ (j-1)*block_size_j;
            end_j = start_j+block_size_j-1;
        else
            start_i = 1+ floor((i-1)*block_size_i/2);
            end_i = start_i+block_size_i-1;
            start_j = 1+ floor((j-1)*block_size_j/2);
            end_j = start_j+block_size_j-1;    
        end
        temp_block = cell_hists(start_i:end_i,start_j:end_j,:);

        if (gauss_filt > 0)
            for ii = 1:B
                temp_block(:,:,ii) = temp_block(:,:,ii).*g;
            end
        end
        
        block_hist = sum(sum(temp_block));
        block_hist = block_hist(:);
        temp_block=temp_block/(norm(block_hist)+0.0001);
        for k = 1:block_size_i
            for l = 1:block_size_j
                cont=cont+1;
                hist = temp_block(k,l,:);
                hist = hist(:);
                H((cont-1)*B+1:cont*B,1)=hist;
            end
        end
    end
end
