function [file, path] = uichoose(basepath, varargin)
% UICHOOSER generic folder and/or file selection dialog box
%
% See also UIGETDIR, UIGETFILE

if nargin == 0
    % Use current working directory if no inputs are passed
    basepath = pwd;
elseif nargin > 1
    % If we have more than 1 argument parse for Name,Value pairs
    p = parseinput(varargin);
end

% Initialize JFileChooser window
% https://docs.oracle.com/javase/8/docs/api/javax/swing/JFileChooser.html
jFC = javax.swing.JFileChooser(basepath);
jFC.setFileSelectionMode(jFC.FILES_AND_DIRECTORIES);

if exist('p', 'var') && p.Results.MultiSelect
    jFC.setMultiSelectionEnabled(true)
else
    jFC.setMultiSelectionEnabled(false)
end

% Switch over possible responses from JFileChooser
returnVal = jFC.showOpenDialog([]);
switch returnVal
    case jFC.APPROVE_OPTION
        % Selection string will be empty if getSelectedFiles is used when
        % MultiSelect is disabled
        if jFC.isMultiSelectionEnabled
            selectionstr = string(jFC.getSelectedFiles());
        else
            selectionstr = string(jFC.getSelectedFile());
        end
    case jFC.CANCEL_OPTION
        % Short-circuit: Return empty array on cancel
        file = [];
        return
    otherwise
        err = MException("uichooser:JFileWindow:unsupportedResult", ...
                         "Unsupported result returned from JFileChooser: %s. " + ...
                         "Please consult the documentation for the current MATLAB Java version (%s)", ...
                         returnVal, string(java.lang.System.getProperty("java.version")));
        err.throw()
end

npicked = numel(selectionstr);
file = strings(npicked, 1);
path = strings(npicked, 1);
for ii = 1:npicked
    [path(ii), filename, ext] = fileparts(selectionstr(ii));
    file(ii) = filename + ext;
end
end

function p = parseinput(in)
    % Validate input Name,Value pairs

    % Initialize verbosely, since inputParser apparently doesn't have a
    % constructor that takes inputs...
    p = inputParser();
    p.FunctionName = 'uichooser';
    p.CaseSensitive = false;
    p.KeepUnmatched = true;
    p.PartialMatching = false;
    
    % Add Name,Value pairs
    p.addParameter('MultiSelect', false, @(x)islogical(x))
    
    % Parse input Name,Value pairs
    p.parse(in{:});
end