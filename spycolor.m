function varargout = spycolor(a, emptyval)
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
%   sz;         marker size [20]
%
% Output variables:
%
%   h:          handle to scatterplot object

% Copyright 2014 Kelly Kearney


if nargin == 1
    emptyval = 0;
end

if iscell(a)
    sz = a{2};
    a  = a{1};
else
    sz = 20 * ones(size(a));
end

if ndims(a) > 3
    error('Can display maximum 3-dimensional array');
end

if ndims(a) == 2

    [m,n] = size(a);

    x = 1:n;
    y = 1:m;

    [x,y] = meshgrid(x,y);

    if isnan(emptyval)
        isemp = isnan(a);
    else
        isemp = a == emptyval;
    end

    h = scatter(x(~isemp), y(~isemp), sz(~isemp), a(~isemp), 'o', 'filled');
    if ~isnan(emptyval)
        isn = isnan(a);
        hold on;
        scatter(x(isn), y(isn), sz(isn), 'k', 'o');
    end

    xlabel(['nz = ' int2str(nnz(a))]);
    set(gca,'xlim',[0 n+1],'ylim',[0 m+1],'ydir','reverse', ...
       'plotboxaspectratio',[n+1 m+1 1]);
else
    [m,n,p] = size(a);
    

    x = 1:n;
    y = 1:m;
    z = 1:p;

    [x,y,z] = meshgrid(x,y,z);

    if isnan(emptyval)
        isemp = isnan(a);
    else
        isemp = a == emptyval;
    end

    h = scatter3(x(~isemp), y(~isemp), z(~isemp), sz(~isemp), a(~isemp), 'o', 'filled');


    xlabel(['nz = ' int2str(nnz(a))]);
    set(gca,'xlim',[0 n+1],'ylim',[0 m+1], 'zlim', [0 p+1], 'ydir','reverse', ...
       'plotboxaspectratio',[n+1 m+1 p+1]);

end

if nargout == 1
    varargout{1} = h;
end