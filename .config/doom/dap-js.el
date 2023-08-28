;;; dap-js.el --- Debug Adapter Protocol mode for Node      -*- lexical-binding: t; -*-

;; Copyright (C) 2022  Elliott Shugerman

;; Author: Elliott Shugerman <eeshugerman@gmail.com>
;; Keywords: languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;; URL: https://github.com/yyoncho/dap-mode
;; Package-Requires: ((emacs "25.1") (dash "2.14.1") (lsp-mode "4.0"))
;; Version: 0.2

;;; Code:

(require 'dap-mode)
(require 'dap-utils)

(defcustom dap-js-debug-path (expand-file-name "vscode/ms-vscode.js-debug"
                                                   dap-utils-extension-path)
  "The path to node vscode extension."
  :group 'dap-js
  :type 'string)

(defcustom dap-js-debug-program `("node"
                                      ,(f-join dap-js-debug-path "extension/src/extension.js"))
  "The path to the JS debugger."
  :group 'dap-js
  :type '(repeat string))

(dap-utils-vscode-setup-function "dap-js" "ms-vscode" "js-debug" dap-js-debug-path)

;; TODO consider what vs spits out in the the terminal when debugging (reformatted):
;; /usr/bin/env
;; 'NODE_OPTIONS=
;;   --require "/Applications/Visual Studio Code.app/Contents/Resources/app/extensions/ms-vscode.js-debug/src/bootloader.bundle.js"
;;   --inspect-publish-uid=http'
;; 'VSCODE_INSPECTOR_OPTIONS=
;; {
;;   "fileCallback": "/var/folders/4x/k0952rkx6ys6lyn62d_xrc240000ks/T/node-debug-callback-26ae24c7cef3ee1c",
;;   "autoAttachMode": "always",
;;   "onlyEntrypoint": false,
;;   "execPath": "/Users/elliott.shugerman/.nvm/versions/node/v14.18.2/bin/node",
;;   "waitForDebugger": "",
;;   "deferredMode": false,
;;   "inspectorIpc": "/var/folders/4x/k0952rkx6ys6lyn62d_xrc240000ks/T/node-cdp.98889-9.sock"
;; }'
;; /Users/elliott.shugerman/.nvm/versions/node/v14.18.2/bin/node \
;;   --nolazy \
;;   -r ts-node/register \
;;   /Users/elliott.shugerman/devel/bodata/service/index.ts

;; SEE ALSO: dap-python.el

(defun dap-js--populate-start-file-args (conf)
  "Populate CONF with the required arguments."
  (let ((conf (-> conf
                  (dap--put-if-absent :dap-server-path dap-js-debug-program)
                  (dap--put-if-absent :type "js")
                  (dap--put-if-absent :cwd default-directory)
                  (dap--put-if-absent :name "JS Debug"))))
    (if (plist-get conf :args)
        conf
      (dap--put-if-absent
       conf :program (read-file-name "Select the file to run:" nil (buffer-file-name) t)))))

(dap-register-debug-provider "js" #'dap-js--populate-start-file-args)

(dap-register-debug-template "JS Run Configuration"
                             (list :type "js"
                                   :cwd nil
                                   :request "launch"
                                   :program nil
                                   :name "JS::Run"))

(provide 'dap-js)
;;; dap-js.el ends here
