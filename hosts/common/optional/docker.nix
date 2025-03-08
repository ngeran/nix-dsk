{
  # Enable Docker
  virtualisation.docker.enable = true;

  # Define the user 'nikos'
  users.users.nikos = {
    isNormalUser = true;
    extraGroups = [ "docker" ]; # Add to docker group
  };
}