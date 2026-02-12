{ ... }:

{
  programs.chromium = {
    enable = true;
    extraOpts = {
      # Restore tabs on startup
      "RestoreOnStartup" = 1;

      # Set DuckDuckGo as the Default Search Provider
      "DefaultSearchProviderEnabled" = true;
      "DefaultSearchProviderName" = "DuckDuckGo";
      "DefaultSearchProviderSearchURL" = "https://duckduckgo.com/?q={searchTerms}";
      "DefaultSearchProviderSuggestURL" = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
      "DefaultSearchProviderNewTabURL" = "https://duckduckgo.com/chrome_newtab";

      "PasswordManagerEnabled" = false;
      "BookmarkBarEnabled" = true;
    };
    extensions = [
      # "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      # # https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=144&x=id%3Dcjpalhdlnbpafiamejdnhcphjbkeiagm%26installsource%3Dondemand%26uc

      # "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite

      # "aeblfdkhhhdcdjpifhhbdiojplfjncoa" # 1password
      # # https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=144&x=id%3Daeblfdkhhhdcdjpifhhbdiojplfjncoa%26installsource%3Dondemand%26uc

      # "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
      # # https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=144&x=id%3Deimadpbcbfnmbkopoojfekhnkhdbieeh%26installsource%3Dondemand%26uc

      # "ldpochfccmkkmhdbclfhpagapcfdljkj" # decentraleyes
      # # https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=144&x=id%3Dldpochfccmkkmhdbclfhpagapcfdljkj%26installsource%3Dondemand%26uc

      # "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # privacy badger
      # # https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=144&x=id%3Dpkehgijcmpdhfbdbbnkijodmdjhbjlgp%26installsource%3Dondemand%26uc

      # "ponfpcnoihfmfllpaingbgckeeldkhle" # enhancer for youtube
      # # https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=144&x=id%3Dponfpcnoihfmfllpaingbgckeeldkhle%26installsource%3Dondemand%26uc
    ];
  };
}
