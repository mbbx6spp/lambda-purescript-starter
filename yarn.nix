{ mkYarnPackage }:
mkYarnPackage {
  name = "hello-purescript";
  src = ./.;
  packageJson = ./package.json;
  yarnLock = ./yarn.lock;
}
