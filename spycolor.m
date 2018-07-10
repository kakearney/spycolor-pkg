function varargout = spycolor(a, emptyval, varargin)
%SPYCOLOR Spy plot with colorbar indicating magnitude of non-zeros
%
% spycolor(a)
% spycolor(a, emptyval)
% spycolor({a, sz}, ...)
% h = spycolor(...)
%
% This function is similar to spy in that it plots the sparsity pattern of
% a matrix, but it also shows the magnitude of the non-missing values via a
% colormap.  It also has special handling for NaNs, showing them as empty
% black circles (unless emptyval is NaN, in which case NaNs are not shown).
%
% Input variables (defaults in []):
%
%   a:          2D or 3D numerical array
%
%   emptyval:   value to be treated as missing [0]
%
%   sz:         marker size, either a scalar, or matrix with the same size
%               and sparsity pattern as a (i.e. must include a size value
%               for all values to be shown, including NaNs if emptyval is
%               not NaN) [20]    
%
% Output variables:
%
%   h:          handles to scatterplot objects; h(1) is the main scatter
%               object (colored, filled), and h(2) is the NaN-circles
%               (black, open) 

% Copyright 2014 Kelly Kearney


% Parse input

if nargin < 2 
    emptyval = 0;
end

if iscell(a)
    sz = a{2};
    a  = a{1};
else
    sz = 20;
end

p = inputParser;
p.addParameter('size',    sz,   @(x) validateattributes(x,'numeric','nonnegative'));
p.addParameter('shownan', true, @(x) validateattributes(x,'logical','scalar'));
p.addParameter('sizenan', 20,   @(x) validateattributes(x,'numeric','nonnegative','scalar'));
p.parse(varargin{:});
Opt = p.Results;


if ndims(a) > 3
    error('Can display maximum 3-dimensional array');
end

% Prep

[m,n,p] = size(a);
x = 1:n;
y = 1:m;
z = 1:p;

% Value coordinates

if isnan(emptyval)
    isemp = isnan(a);
else
    isemp = a == emptyval;
end

idx = find(~isemp);
[ir,ic,ip] = ind2sub(size(a), find(~isemp));
xs = x(ic);
ys = y(ir);
zs = z(ip);
as = a(~isemp);

if isequal(size(sz),size(a))
    szs = sz(~isemp);
else
    szs = sz;
end

% NaN coordinates (if applicable)

if isnan(emptyval)
    xn = [];
    yn = [];
    zn = [];
    szn = 20;
else
    isn = isnan(a);
    if isequal(size(sz),size(a))
        szn = sz(isn);
    else
        szn = sz;
    end

    [ir,ic,ip] = ind2sub(size(a), find(isn));
    xn = x(ic);
    yn = y(ir);
    zn = z(ip);
end
    
% Plot

if p == 1 % 2D
    h(1) = scatter(xs, ys, szs, as, 'o', 'filled');
    hold on;
    h(2) = scatter(xn, yn, szn, 'k', 'o');
    
    xlabel(['nz = ' int2str(nnz(a))]);
    set(gca,'xlim',[0 n+1],'ylim',[0 m+1],'ydir','reverse', ...
       'plotboxaspectratio',[n+1 m+1 1]);
else % 3D
    h(1) = scatter3(xs, ys, zs, szs, as, 'o', 'filled');
    hold on;
    h(2) = scatter3(xn, yn, zn, szn, 'k', 'o');
    
    xlabel(['nz = ' int2str(nnz(a))]);
    set(gca,'xlim',[0 n+1],'ylim',[0 m+1], 'zlim', [0 p+1], 'ydir','reverse', ...
       'plotboxaspectratio',[n+1 m+1 p+1]);
end

% Output

if nargout == 1
    varargout{1} = h;
end