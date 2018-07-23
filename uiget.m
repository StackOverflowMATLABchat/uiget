function [file, path] = uiget(basepath, varargin)
% UIGET generic folder and/or file selection dialog box
%
% Syntax:
%     file = uiget()
%     [file, path] = uiget()
%     ___ = uiget(basepath)
%     ___ = uiget(basepath, Name, Value)
%
% Available Name, Value Pairs:
%     MultiSelect      - Specify whether a user can select multiple files or folders
%     ScalarPathOutput - Specify whether a scalar path is output when using MultiSelect
%     Title            - Specify a custom dialog title
%     ExtensionFilter  - Specify a custom file extension filter
%
% See README.md for detailed documentation and examples
%
% See also UIGETDIR, UIGETFILE

if nargin == 0
    % Use current working directory if no inputs are passed
    basepath = pwd;
elseif nargin == 1
    % Check for existence of basepath as a directory, default to current
    % directory if it doesn't exist
    if ~exist(basepath, 'dir')
        basepath = pwd;
    end
end

% Parse additional inputs
p = buildParser();
p.parse(varargin{:});

% Initialize JFileChooser window
% https://docs.oracle.com/javase/8/docs/api/javax/swing/JFileChooser.html
jFC = javax.swing.JFileChooser(basepath);
jFC.setFileSelectionMode(jFC.FILES_AND_DIRECTORIES)
jFC.setDialogTitle(p.Results.Title)

% Build file filter
if ~isempty(p.Results.ExtensionFilter)
    extensions = parsefilter(p.Results.ExtensionFilter(:, 1));
    
    nfilters = size(p.Results.ExtensionFilter, 1);
    for ii = 1:nfilters
        if isempty(extensions{ii})
            % Catch invalid extension specs
            continue
        end
        jExtensionFilter = javax.swing.filechooser.FileNameExtensionFilter(p.Results.ExtensionFilter{ii, 2}, extensions{ii});
        jFC.addChoosableFileFilter(jExtensionFilter)
    end
    
    tmp = jFC.getChoosableFileFilters();
    jFC.setFileFilter(tmp(2))
end

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
        file = "";
        path = "";
        return
    otherwise
        err = MException("uiget:JFileWindow:unsupportedResult", ...
                         "Unsupported result returned from JFileChooser: %s.\n" + ...
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
    
    % Because we can select directories, we want to have them output as a
    % path and not a file
    if exist(fullfile(path(ii), file(ii)), 'dir')
        path(ii) = fullfile(path(ii), file(ii));
        file(ii) = "";
    end
end

% Since we've now adjusted file in cases where a folder was selected, warn
% the user if file is going to be empty and they're not requesting path to
% go with it
emptyfiletest = (file == '');
if nargout <= 1 && any(emptyfiletest)
    warning("uiget:uiget:nopathoutputrequested", ...
            "One or more paths have been selected without requesting the path output.\n" + ...
            "Please specify a second output to uiget to receive these paths." ...
            );
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
                "Multiple unique paths selected, ignoring %u extra selections.", ...
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
p.addParameter('ExtensionFilter', [], @(x)validateattributes(x, {'cell'}, {'ncols', 2}))
end

function extensions = parsefilter(incell)
% Parse the extension filter extensions into a format usable by 
% javax.swing.filechooser.FileNameExtensionFilter
% 
% Since we're keeping with the uigetdir-esque extension syntax
% (e.g. *.extension), we need strip off '*.' from each for compatibility
% with the Java component.
extensions = cell(size(incell));
for ii = 1:numel(incell)
    exp = '\*\.(\w+)';
    extensions{ii} = string(regexp(incell{ii}, exp, 'tokens'));
end
end