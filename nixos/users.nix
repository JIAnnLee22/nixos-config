{ ... }:

{
  users.users.jiannlee22 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "kvm" "adbusers" "uinput" ];
  };
}
