{ lock, ocamlPackages }:

self: super: {
  straightBuild = { pname, ... }@args: self.trivialBuild ({
    ename = pname;
    version = "1";
    src = lock pname;
    buildPhase = ":";
  } // args);

  doom-snippets = self.straightBuild {
    pname = "doom-snippets";
    postInstall = ''
      cp -r *-mode $out/share/emacs/site-lisp
    '';
  };

  explain-pause-mode = self.straightBuild {
    pname = "explain-pause-mode";
  };

  evil-markdown = self.straightBuild {
    pname = "evil-markdown";
  };

  evil-org = self.straightBuild {
    pname = "evil-org-mode";
    ename = "evil-org";
  };

  evil-quick-diff = self.straightBuild {
    pname = "evil-quick-diff";
  };

  magit = super.magit.overrideAttrs (esuper: {
    preBuild = ''
      make VERSION="${esuper.version}" -C lisp magit-version.el
    '';
  });

  nose = self.straightBuild {
    pname = "nose";
  };

  org-contrib = self.straightBuild {
    pname = "org-contrib";
    installPhase = ''
      mkdir -p $out/share/emacs/site-lisp
       cp -r lisp/* $out/share/emacs/site-lisp
    '';
  };

  org = self.straightBuild rec {
    pname = "org";
    version = "9.4";
    installPhase = ''
      LISPDIR=$out/share/emacs/site-lisp
      install -d $LISPDIR

      cp -r * $LISPDIR

      cat > $LISPDIR/lisp/org-version.el <<EOF
      (fset 'org-release (lambda () "${version}"))
      (fset 'org-git-version #'ignore)
      (provide 'org-version)
      EOF
    '';
  };

  org-yt = self.straightBuild {
    pname = "org-yt";
  };

  php-extras = self.straightBuild {
    pname = "php-extras";
  };

  restart-emacs = super.restart-emacs.overrideAttrs (esuper: {
    patches = [ ./patches/restart-emacs.patch ];
  });

  revealjs = self.straightBuild {
    pname = "revealjs";

    installPhase = ''
      LISPDIR=$out/share/emacs/site-lisp
      install -d $LISPDIR

      cp -r * $LISPDIR
    '';
  };

  rotate-text = self.straightBuild {
    pname = "rotate-text";
  };

  sln-mode = self.straightBuild {
    pname = "sln-mode";
  };

  so-long = self.straightBuild {
    pname = "emacs-so-long";
    ename = "so-long";
  };

  tree-sitter = super.tree-sitter.overrideAttrs (esuper: {
    postInstall = ''
      ln -s ${super.tsc}/share/emacs/site-lisp/elpa/${super.tsc.name}/* \
        $out/share/emacs/site-lisp/elpa/${esuper.pname}-${esuper.version}/
    '';
  });

  ts-fold = self.straightBuild {
    pname = "ts-fold";
  };

  ob-racket = self.straightBuild {
    pname = "ob-racket";
  };

  format-all = self.straightBuild {
    pname = "format-all";
  };

  # dune has a nontrivial derivation, which does not buildable from the melpa
  # wrapper falling back to the one in nixpkgs
  dune = ocamlPackages.dune_2.overrideAttrs (old: {
    # Emacs derivations require an ename attribute
    ename = old.pname;

    # Need to adjust paths here match what doom expects
    postInstall = ''
      mkdir -p $out/share/emacs/site-lisp/editor-integration
      ln -snf $out/share/emacs/site-lisp $out/share/emacs/site-lisp/editor-integration/emacs
    '';
  });

  vterm = super.vterm.overrideAttrs (old: { src = lock "vterm"; });

  consult = super.consult.overrideAttrs (old: { src = lock "consult"; });

  org-ai = self.straightBuild {
    pname = "org-ai";
  };

  gptel = self.straightBuild {
    pname = "gptel";
  };

}
