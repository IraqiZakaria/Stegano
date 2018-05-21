function [dh,h,cp,zq,structfunc] = dwtleader_shearlet(img,shearletSystem)

%img = double(imread('lena.jpg'));
%shearletSystem = CSHRMgetContEdgeSystem(size(img,1),size(img,2));
%ncount(jj) = numel(leaders{jj})?;
coeffs = coeffs_shearlet(img,shearletSystem);
List=pseudo_leaders_shearlet_quick(coeffs,shearletSystem);


size(coeffs);
A=size(coeffs);
scales=A(4);
q=-5:5;
j1=3;
J=7;


Nq = numel(q);
Nest=A(1)*A(2);
Dq = zeros(Nq,Nest);
Hq = zeros(Nq,Nest);
Cp = zeros(3,Nest);
zetaq = zeros(Nq,Nest);
for jj = 1:scales
    [zetaq(:,jj),Dq(:,jj), Hq(:,jj), Cp(:,jj)] = UVR(List,jj);
end

Cp = Cp*log2(exp(1));
Y = [zetaq; Dq; Hq; Cp];
xj = log2([1:scales]);
variable1=size(Y);
variable2=size(xj);
J=min(variable2(2),variable1(2));
Y = Y(:,j1:J);
xj = xj(j1:J);
%Y = Y(:,j1:end);
%xj = xj(j1:end);

%ncount = Nest*ones(1,J-j1+1);

%Leaders are not defined at level 1

% Forming multiresolution structure functions
structfunc.Tq = Y';
%structfunc.weights = ncount;
structfunc.logscales = xj;
% Create design matrix
X = ones(length(structfunc.logscales),2);
X(:,2) = structfunc.logscales;
% Least-squares regression with weigths
size(X);
size(structfunc.Tq);

betahat = lscov(X,structfunc.Tq);
% Ignore intercept terms -- use only slopes
betahat = betahat(2,:);
zq = betahat(1:Nq);
dh = betahat(Nq+1:2*Nq)+1;
h = betahat(2*Nq+1:3*Nq);
cp = betahat(3*Nq+1:end);




