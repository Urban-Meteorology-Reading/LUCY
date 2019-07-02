function [ alatmin,alatmax,alonmin,alonmax ] = adjextent( a,aa,b,bb,res )
% To convert latitude and longitude divisable by input resolution
a=round(a*3600);
aa=round(aa*3600);
b=round(b*3600);
bb=round(bb*3600);

alatmin=( a-(mod(a,res)));
alonmin=(b-(mod(b,res)));

alatmax=( aa+(res-(mod(aa,res))));
alonmax=(bb+(res-(mod(bb,res))));

alatmin=(alatmin/3600);
alatmax=(alatmax/3600);
alonmin=(alonmin/3600);
alonmax=(alonmax/3600);
end

