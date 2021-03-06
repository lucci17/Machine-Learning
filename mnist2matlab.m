function mnist2matlab(mnist_dir)
% function MNIST2MATLAB(MNIST_DIR)
% Converts and saves MNIST datasets from lush IDX data as Matlab files.
%
% INPUT
%   MNIST_DIR   - directory to MNIST dataset
%
% Matlab code by Nikolay Chumerin, K.U.Leuven, Belgium.
% Nikolay.Chumerin@med.kuleuven.be
% http://simone.neuro.kuleuven.be/nick
% Last update: 2009-09-08

    % read test data file
    images = permute(read_idx_data([mnist_dir 't10k-images-idx3-ubyte']), [2 3 1]); %#ok<*NASGU>
    save([mnist_dir 'test_images.mat'], 'images')

    labels = read_idx_data([mnist_dir 't10k-labels-idx1-ubyte'])'; %#ok<*NASGU>
    save([mnist_dir 'test_labels.mat'], 'labels')

    % read train data file
    images = permute(read_idx_data([mnist_dir 'train-images-idx3-ubyte']), [2 3 1]);
    save([mnist_dir 'train_images.mat'], 'images')

    labels = read_idx_data([mnist_dir 'train-labels-idx1-ubyte'])';
    save([mnist_dir 'train_labels.mat'], 'labels')
    
end % of function MNIST2MATLAB

function data = read_idx_data(filename)
% function DATA = READ_IDX_DATA(FILENAME)
% Read data from lush IDX data file.
%
% INPUT
%   FILENAME    - name of the lush IDX file
%
% OUTPUT
%   DATA        - result data
%
% Matlab code by Nikolay Chumerin, K.U.Leuven, Belgium.
% Nikolay.Chumerin@med.kuleuven.be
% http://simone.neuro.kuleuven.be/nick
% Last update: 2009-01-12

    % check parameters
    if ~exist('filename', 'var') || isempty(filename),
        error('Should be at least one parameter - filename!');
    end

    % try to open file
    try
        f = fopen(filename);
    catch %#ok<*CTCH>
        error(['Can''data open file ' filename]);
    end

    % check file's signature / magic number
    magic = int32(fread(f, 4, 'uint8'));

    switch magic(3),
        case 08, format = 'uint8';      % 0x08: unsigned byte
        case 09, format = 'int8';       % 0x09: signed byte
        case 13, format = 'single';     % 0x0D: float (4 bytes)
        case 14, format = 'double';     % 0x0E: double (8 bytes)
        otherwise
            error('Unsupported data format');
    end % of format switch

    % Read dimensions
    ndim = double(magic(4));                % number of dimensions
    dims = fread(f, ndim, 'uint32', 'ieee-be')'; % dimensions

    if ndim == 1,
        dims = [dims 1];
        ndim = 2;
    end

    data = reshape(fread(f, prod(dims), ['*' format]), fliplr(dims)); % reshape
    data = permute(data, ndim:-1:1);       % permute dimensions

    fclose(f);  % close the file
    
end % of function READ_IDX_DATA