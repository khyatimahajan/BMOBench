###############################################################################
#
#   As described by Huband et al. in "A Scalable Multi-objective Test Problem
#   Toolkit", in C. A. Coello Coello et al. (Eds.): EMO 2005, LNCS 3410, 
#   pp. 280�295, 2005, Springer-Verlag Berlin Heidelberg 2005.
#
#   Example I2.
#
#   This file is part of a collection of problems developed for
#   derivative-free multiobjective optimization in
#   A. L. Cust�dio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
#   Direct Multisearch for Multiobjective Optimization, 2010.
#
#   Written by the authors in June 1, 2010.
#
###############################################################################

param M := 3;
param k := 4;
param l := 4;
param n := k+l;

param pi := 4*atan(1);
param pi2:= 2*atan(1);

param S {m in 1..M} := 1;

# neq WFG3
param A {i in 1..M-1} := 1;


# problem variables
param zmax {i in 1..n} := 1;
var z{i in 1..n} >=0, <= zmax[i];

# transform z into [0,1] set
var y{i in 1..n} = z[i]/zmax[i];

# first level mapping
param w{1..n}, default 1.0;
param AA := 0.98/49.98;
param BB := 0.02;
param CC := 50;
var r_sum{i in 1..n-1} = (sum {j in i+1..n} (w[j]*y[j]))/(sum {j in i+1..n} w[j]);
var t1{i in 1..n} = if i<n then y[i]^(BB+(CC-BB)*(AA-(1-2*r_sum[i])*abs(floor(0.5-r_sum[i])+AA)))
    else y[i];

# second level mapping
var t2{i in 1..n} = if i<=k then t1[i]
    else abs(t1[i]-0.35)/abs(floor(0.35-t1[i])+0.35);

# third level mapping
# w already defined
var t3{i in 1..M} = if i<=M-1 then (sum {j in ((i-1)*k/(M-1)+1)..(i*k/(M-1))} (w[j]*t2[j]))/(sum {j in ((i-1)*k/(M-1)+1)..(i*k/(M-1))} w[j])
    else (sum {j in k+1..n} (w[j]*t2[j]))/(sum {j in k+1..n} w[j]);

# Define objective function variables
var x{i in 1..M} = if i<=M-1 then max(t3[M],A[i])*(t3[i]-0.5)+0.5
    else t3[M];

# Define objective function function h
var h{m in 1..M} = if m==1 then prod {i in 1..M-1} sin(x[i]*pi2)
    else if m<=M-1 then (prod {i in 1..M-m} sin(x[i]*pi2))*cos(x[M-m+1]*pi2)
        else cos(x[1]*pi2);


# The objective functions
minimize fobj {m in 1..M}:
    x[M]+S[m]*h[m];


