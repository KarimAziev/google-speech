;;; google-speech.el --- Speak out text using Google's `Text-to-Speech' service -*- lexical-binding: t; -*-

;; Copyright (C) 2023 Karim Aziiev <karim.aziiev@gmail.com>

;; Author: Karim Aziiev <karim.aziiev@gmail.com>
;; URL: https://github.com/KarimAziev/google-speech
;; Version: 0.1.0
;; Keywords: tools
;; SPDX-License-Identifier: GPL-3.0-or-later
;; Package-Requires: ((emacs "24.1"))

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Speak out text using Google's `Text-to-Speech' service

;;; Code:

(defvar google-speech-proc-name "google_speech")

;;;###autoload
(defun google-speech ()
  "Convert selected text to speech using Google's `Text-to-Speech' service"
  (interactive)
  (if (get-process google-speech-proc-name)
      (kill-process (get-process google-speech-proc-name))
    (let* ((buff-name (format "*google-speech*"))
           (buffer (get-buffer buff-name))
           (str (replace-regexp-in-string
                 "[^a-z0-9,.\s\t\r\f\n-]"
                 " "
                 (if
                     (region-active-p)
                     (buffer-substring-no-properties
                      (region-beginning)
                      (region-end))
                   (buffer-substring-no-properties
                    (point-min)
                    (point))))))
      (if (buffer-live-p buffer)
          (kill-buffer buffer)
        (let ((proc))
          (setq proc (start-process
                      google-speech-proc-name buffer google-speech-proc-name
                      str))
          (set-process-sentinel
           proc
           (lambda (process _state)
             (when (buffer-live-p (process-buffer process))
               (kill-buffer (process-buffer process))))))))))

(provide 'google-speech)
;;; google-speech.el ends here