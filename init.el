;;==========================================
;;全域設定
;;==========================================
(set-language-environment 'UTF-8) ;設定語系
(fset 'yes-or-no-p 'y-or-n-p) ;將 yes/no 替換成 y/n
(setq frame-title-format "Lorex@%b") ;顯示目前編輯文件
(tool-bar-mode -1) ;隱藏工具列
(menu-bar-mode -1) ;隱藏選單
(setq scroll-margin 3) ;接近螢幕邊緣三行時就開始滾動

;;C/C++ 編譯快捷鍵
;(define-key c-mode-base-map [(f7)] 'compile)

;;==========================================
;;時間相關
;;==========================================
(display-time-mode 1) ;顯示時間
(setq display-time-24hr-format t) ;24小時格式顯示
(setq display-time-day-and-date t) ;顯示日期

;;==========================================
;;編輯器顯示相關
;;==========================================
(mouse-avoidance-mode 'animate) ;游標移到鼠標旁的時候，鼠標會彈開
(global-linum-mode t) ;行號顯示
(column-number-mode t) ;顯示列號

(global-hl-line-mode 1) 
(set-face-background 'highlight "#222")
(set-face-foreground 'highlight nil)
(set-face-underline-p 'highlight t) ;底線顯示當前行

(show-paren-mode t) ;突顯括號位置
(setq show-paren-style 'parentheses) ;;括號以配對顯示，不要閃爍
(setq auto-image-file-mode t) ;可以直接打開/顯示圖片

;;==========================================
;;插件管理程式
;;==========================================
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("elpa" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;;自動補完
(require 'auto-complete)
(defcustom mycustom-system-include-paths '("./include/" "/opt/local/include" "/usr/include" )
  "This is a list of include paths that are used by the clang auto completion."
  :group 'mycustom
  :type '(repeat directory)
  )
(require 'auto-complete-config)
(ac-config-default)

;;clang補完
(require 'auto-complete-clang)
(setq clang-completion-suppress-error 't)
(setq ac-clang-flags
      (mapcar (lambda (item)(concat "-I" item))
              (append
               mycustom-system-include-paths
               )
              )
      )
 
(defun my-ac-clang-mode-common-hook()
  (define-key c-mode-base-map [(tab)] 'ac-complete-clang)
)
 (add-hook 'c-mode-common-hook 'my-ac-clang-mode-common-hook)

;;yasnippet補完
(require 'yasnippet)
(yas-global-mode 1)

;;c/c++標頭檔補完
(defun my:ac-c-header-init () ;初始化插件
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers)
  (add-to-list 'achead:include-directories '"/usr/include/c++/4.9") ;要掃描的目錄
) 
(add-hook 'c++-mode-hook 'my:ac-c-header-init)
(add-hook 'c-mode-hook 'my:ac-c-header-init)

;;修正 iedit bug
(define-key global-map (kbd "C-c ;") 'iedit-mode)

;;flymake 指導 google coding style
(defun my:flymake-google-init() ;初始化插件
  (require 'flymake-google-cpplint)
  (custom-set-variables
   '(flymake-google-cpplint-command "/usr/local/bin/cpplint"))
  (flymake-google-cpplint-load) ;載入
)
(add-hook 'c-mode-hook 'my:flymake-google-init)
(add-hook 'c++-mode-hook 'my:flymake-google-init)

;;google-c-style
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

;;CEDET 補完
(semantic-mode 1)
(defun my:add-semantic-to-ac()
  (add-to-list 'ac-sources 'ac-source-semantic)
)
(add-hook'c-mode-common-hook 'my:add-semantic-to-ac)

(global-ede-mode 1)
(global-semantic-idle-scheduler-mode 1)

;;PHP補完設定
(require 'web-mode)

(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(defun my:web-mode-hook()
  ;;Indent
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 4)
  (setq web-mode-code-indent-offset 4)
  (setq web-mode-indent-style 2)
  
  ;;高亮HTML元素
  (setq web-mode-enable-current-element-highlight t)

  ;;PHP補完
  (require 'php-completion)
  (php-completion-mode t)
  (when (require 'auto-complete nil t)
    (make-variable-buffer-local 'ac-sources)
    (add-to-list 'ac-sources 'ac-source-php-completion)
    (auto-complete-mode t))
)

(add-hook 'web-mode-hook 'my:web-mode-hook)


;;==========================================
;;主題
;;==========================================
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-calm-forest)))
(put 'erase-buffer 'disabled nil)
