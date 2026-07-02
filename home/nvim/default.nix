{ ... }:

{
  xdg.configFile = {
    "nvim/init.lua".source = ./init.lua;
    "nvim/core/basic.lua".source = ./core/basic.lua;
    "nvim/plugin/plugin.lua".source = ./plugin/plugin.lua;
  };
}
