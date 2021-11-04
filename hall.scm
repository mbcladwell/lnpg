(hall-description
  (name "lnpg")
  (prefix "")
  (version "0.1")
  (author "mbc")
  (copyright (2021))
  (synopsis "")
  (description "")
  (home-page "www.labsolns.com")
  (license gpl3+)
  (dependencies `())
  (skip ())
  (files (libraries
           ((directory
              "lnpg"
              ((scheme-file "artass") (scheme-file "gplot")))
            (scheme-file "lnpg")))
         (tests ((directory "tests" ())))
         (programs ((directory "scripts" ())))
         (documentation
           ((text-file "AUTHORS")
            (text-file "NEWS")
            (directory
              "doc"
              ((info-file "lnpg")
               (texi-file "version")
               (info-file "version")
               (texi-file "lnpg")
               (text-file ".dirstamp")
               (text-file "stamp-vti")))
            (text-file "COPYING")
            (text-file "HACKING")
            (symlink "README" "README.org")
            (org-file "README")))
         (infrastructure
           ((scheme-file "hall")
            (text-file ".gitignore")
            (scheme-file "guix")))))
