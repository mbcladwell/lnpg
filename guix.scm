(use-modules
  (guix packages)
  ((guix licenses) #:prefix license:)
  (guix download)
  (guix build-system gnu)
  (gnu packages)
  (gnu packages databases)
;;  (labsolns postgresql-client)
 ;; (labsolns artanis)
  (gnu packages autotools)
  (gnu packages guile)
  (gnu packages guile-xyz)
  (gnu packages pkg-config)
  (gnu packages texinfo)
   (gnu packages maths)
  )

(package
  (name "lnpg")
  (version "0.1")
  (source "./lnpg-0.1.tar.gz")
  (build-system gnu-build-system)
  (arguments `(#:tests? #false ; there are none
			#:phases (modify-phases %standard-phases
    		       (add-after 'unpack 'patch-prefix
			       (lambda* (#:key inputs outputs #:allow-other-keys)
				 (substitute* '("scripts/install-pg.sh"
						"lnpg/lnpg.scm")
						(("abcdefgh")
						(assoc-ref outputs "out" )) )
					#t))		    
		       (add-before 'install 'make-scripts-dir
			       (lambda* (#:key outputs #:allow-other-keys)
				    (let* ((out  (assoc-ref outputs "out"))
					   (scripts-dir (string-append out "/scripts"))
					   (bin-dir (string-append out "/bin"))
					   (dummy (install-file "scripts/install-pg.sh" bin-dir))
					   (dummy (mkdir-p scripts-dir)))            				       
				       (copy-recursively "./scripts" scripts-dir)
				       #t)))
		       (add-after 'install 'wrap-install-pg
				  (lambda* (#:key inputs outputs #:allow-other-keys)
				    (let* ((out (assoc-ref outputs "out"))
					   (bin-dir (string-append out "/bin"))
					   (dummy (chmod (string-append out "/bin/install-pg.sh") #o555 ))) ;;read execute, no write
				      (wrap-program (string-append out "/bin/install-pg.sh")
						    `( "PATH" ":" prefix  (,bin-dir) ))		    
				      #t)))	       
		       )))
  (native-inputs
    `( 
    ("autoconf" ,autoconf)
      ("automake" ,automake)
      ("pkg-config" ,pkg-config)
      ("texinfo" ,texinfo) 
     ;; ("util-linux" ,util-linux)   
     ))
  (inputs `(("guile" ,guile-3.0)
	    ("gnuplot" ,gnuplot)))
  (propagated-inputs `( ;("artanis" ,artanis)
			("postgresql" ,postgresql)
			;;("postgresql-client" ,postgresql-client)
			))
  (synopsis "")
  (description "")
  (home-page "www.labsolns.com")
  (license license:gpl3+))

