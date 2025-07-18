# Version Management Utilities
{ lib }:

let
  # Validate semantic version format
  isValidVersion = version: 
    if version == "latest" then true
    else builtins.match "[0-9]+\\.[0-9]+\\.[0-9]+" version != null;

  # Compare two semantic versions
  compareVersions = v1: v2:
    if v1 == "latest" then 1
    else if v2 == "latest" then -1
    else
      let
        parseVersion = v: map lib.toInt (lib.splitString "." v);
        parts1 = parseVersion v1;
        parts2 = parseVersion v2;
        
        compareParts = p1: p2:
          if p1 == [] && p2 == [] then 0
          else if p1 == [] then -1
          else if p2 == [] then 1
          else
            let
              head1 = lib.head p1;
              head2 = lib.head p2;
            in
            if head1 < head2 then -1
            else if head1 > head2 then 1
            else compareParts (lib.tail p1) (lib.tail p2);
      in
      compareParts parts1 parts2;

  # Get latest version from a version set
  getLatestVersion = versions:
    let
      versionList = lib.attrNames versions;
      nonLatestVersions = lib.filter (v: v != "latest") versionList;
      sortedVersions = lib.sort (v1: v2: compareVersions v1 v2 > 0) nonLatestVersions;
    in
    if sortedVersions == [] then "latest"
    else lib.head sortedVersions;

  # Validate version set
  validateVersions = versions:
    let
      invalidVersions = lib.filter (v: !isValidVersion v) (lib.attrNames versions);
    in
    if invalidVersions != [] then
      throw "Invalid versions found: ${lib.concatStringsSep ", " invalidVersions}"
    else versions;

in {
  inherit isValidVersion compareVersions getLatestVersion validateVersions;
}
