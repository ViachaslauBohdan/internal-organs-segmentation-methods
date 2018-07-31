clear all;clc;
arr = [5 115 0 0
       1115 11115 0 0
       0 0 0 0
       0 0 0 0 ]

         
S = qtdecomp(arr,1)
disp(full(S));