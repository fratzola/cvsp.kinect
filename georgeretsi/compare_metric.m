function [p,intra_d,inter_d] = compare_metric(h,obs_ind,funct);
% h -> data features
% obs_ind -> data tagging
% funct -> (use : @(function_name)) distance metric

    [intra_d,inter_d_m] = compare_matrices(h,obs_ind,funct);
    inter_d_m = inter_d_m + 100*eye(size(inter_d_m));
    inter_d = min(inter_d_m)';
    p = sum(intra_d./inter_d);

function [intra_d,inter_d] = compare_matrices(h,obs_ind,funct)

p = mypdist(h,funct);
P = squareform(p);

N = length(obs_ind);

intra_d = zeros(N,1);
for i = 1:N
   ind = obs_ind{i};
   intra_temp = zeros(length(ind),1);
   for j = 1:length(ind)
       intra_temp(j) = max(P(ind(j),ind));
   end
   intra_d(i) = max(intra_temp);
end

inter_d_t = zeros((N*(N-1))/2,1);
count = 1;
for i = 1:N
   ind = obs_ind{i};
   for j = i+1:N
       ind2 = obs_ind{j};
       inter_temp = zeros(length(ind),1);
       for k = 1:length(ind)              
           inter_temp(k) = min(P(ind(k),ind2));
       end
       inter_d_t(count) = min(inter_temp);
       count = count+1;
   end
end
inter_d = squareform(inter_d_t);