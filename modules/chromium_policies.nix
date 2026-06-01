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
  };
}
