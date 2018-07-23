![Minimum Version](https://img.shields.io/badge/Requires-R2016b%20%28v8.4%29-orange.svg)

# UIGET

`uiget` opens a dialog box that allows the user to select folder(s) and/or file(s) in a single UI. This is designed as a generic alternative to MATLAB's more specific UI selection tools: [`uigetdir`](https://www.mathworks.com/help/matlab/ref/uigetdir.html) and [`uigetfile`](https://www.mathworks.com/help/matlab/ref/uigetfile.html)

This tool utilizes MATLAB's [`string`](https://www.mathworks.com/help/matlab/ref/string.html) objects, introduced in R2016b.

This utility was inspired by: [Making a dialog where the user can choose either a file or a folder](https://stackoverflow.com/questions/51440968/making-a-dialog-where-the-user-can-choose-either-a-file-or-a-folder), a Q&A posted by SO user [Dev-iL](https://stackoverflow.com/users/3372061/dev-il) on 2018-07-20

## Syntax

`file = uiget()`

`[file, path] = uiget()`

`___ = uiget(basepath)`

`___ = uiget(___, Name, Value)`


## Examples


## Name, Value Pairs
| Parameter | Description | Type | Default Value |
| :--:      | :--:        | :--: | :--:          |
| `'MultiSelect'` | Specify whether a user can select multiple files or folders | `logical` | `false` |
| `'ScalarPathOutput'` | Specify whether a scalar path is output when using `'MultiSelect'` | `logical` | `false` |
| `'Title'` | Specify a custom dialog title | `char` vector, `string` scalar | `'Select File or Folder'` |
| `'ExtensionFilter'` | Specify a custom file extension filter | `{n x 2}` `cell` array of text, where each row is `{extension(s), description}`<sup>1, 2</sup> | All Files |

1. Extension filter syntax follows that of [uigetfile](https://www.mathworks.com/help/matlab/ref/uigetfile.html), see [the documentation](https://www.mathworks.com/help/matlab/ref/uigetfile.html#mw_d51d3e26-4b0d-4017-a1ed-28162572b6bc) for additional details and examples.

2. The "All Files" file filter is already provided by the dialog window, so explicitly specifying it will create an additional entry