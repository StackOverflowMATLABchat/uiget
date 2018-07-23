function [file, path] = uiget(basepath, varargin)
% UIGET generic folder and/or file selection dialog box
%
% See also UIGETDIR, UIGETFILE

if nargin == 0
    % Use current working directory if no inputs are passed
    basepath = pwd;
end

% Parse additional inputs
p = buildParser();
p.parse(varargin{:});

% Initialize JFileChooser window
% https://docs.oracle.com/javase/8/docs/api/javax/swing/JFileChooser.html
jFC = javax.swing.JFileChooser(basepath);
jFC.setFileSelectionMode(jFC.FILES_AND_DIRECTORIES);
jFC.setDialogTitle(p.Results.Title)

if p.Results.MultiSelect
    jFC.setMultiSelectionEnabled(true)
    
    % Change title if default is being used
    if any(strcmp(p.UsingDefaults, 'Title'))
        jFC.setDialogTitle('Select File(s) and/or Folder(s)')
    end
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
            selectionStr = string(jFC.getSelectedFiles());
        else
            selectionStr = string(jFC.getSelectedFile());
        end
    case jFC.CANCEL_OPTION
        % Short-circuit: Return empty array on cancel
        file = [];
        path = [];
        return
    otherwise
        err = MException("uiget:JFileWindow:unsupportedResult", ...
                         "Unsupported result returned from JFileChooser: %s. " + ...
                         "Please consult the documentation for the current MATLAB Java version (%s)", ...
                         returnVal, string(java.lang.System.getProperty("java.version")));
        err.throw()
end

npicked = numel(selectionStr);
file = strings(npicked, 1);
path = strings(npicked, 1);
for ii = 1:npicked
    [path(ii), filename, ext] = fileparts(selectionStr(ii));
    file(ii) = filename + ext;
end

% Simplify path output if needed
if p.Results.ScalarPathOutput
    % Check for number of unique paths
    % If more than one is present, use the first & throw a warning
    uniquepaths = unique(path);
    nuniquepaths = numel(uniquepaths);
    if nuniquepaths == 1
        path = uniquepaths;
    elseif nuniquepaths > 1
        path = uniquepaths(1);
        
        warning("uiget:ScalarPathOutput:multipleuniquepaths", ...
                "Multiple unique paths selected, ignoring %u extra selections", ...
                nuniquepaths - 1);
    end
end

end

function p = buildParser()
    % Validate input Name,Value pairs

    % Initialize verbosely, since inputParser apparently doesn't have a
    % constructor that takes inputs...
    p = inputParser();
    p.FunctionName = 'uiget';
    p.CaseSensitive = false;
    p.KeepUnmatched = true;
    p.PartialMatching = false;
    
    % Add Name,Value pairs
    p.addParameter('MultiSelect', false, @(x)islogical(x))
    p.addParameter('ScalarPathOutput', false, @(x)islogical(x))
    p.addParameter('Title', 'Select File or Folder', @(x)validateattributes(x, {'char', 'string'}, {'scalartext'}))
end