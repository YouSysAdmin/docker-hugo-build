# docker-hugo-build
![hugo-build status](https://tc.sysalex.com/app/rest/builds/buildType:(id:buildtools_DockerHugoBuild)/statusIcon) ![docker hub pull](https://img.shields.io/docker/pulls/yousysadmin/docker-hugo-build.svg)  
CI/CD toolchain for build hugo static site

`scss` tools and `minify` included

Build site:
```
docker run --rm -v $PWD:/source yousysadmin/docker-hugo-build hugo --minify
```
