clear;
F = csvread('small_num.csv');
in_a    = -1:0.0015:1;
in_b    = -1:0.0015:1;
err     = (F(:,3))';
err_mat = reshape(err, 1334, 1334);

mesh(in_a, in_b, err_mat);
