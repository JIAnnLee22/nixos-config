
{ pkgs, ... }:
{
  programs.foot = {
	  enable = true;
		theme = "catppuccin-mocha";
		enableBashIntegration = true;
		settings = {
		  main = {
			  font = "monospace:size=14";
			};
		  colors-light = {
				alpha = "0.25";
			};
		  colors-dark = {
				alpha = "0.25";
			};
			scrollback = {
			  lines = 100000;
      };
			cursor = {
			  blink = true;
			};
		};
	};
}
