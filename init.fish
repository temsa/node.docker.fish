# sudo npm i -g semver-node-cli json

function node.docker
  mkdir -p .docker

  set pkgversion (cat package.json | json engines.node | xargs semver-node --resolve)
  set cached_node_version (cat .docker/node-version)
  set p (echo $PWD | sed s/\\/// | sed s/\\//-/g);

  #echo "argv:" (count $argv)
  #echo (test (count $argv) -gt 1)
  if test -n $cached_node_version
    set v $cached_node_version
    echo "cached version $v"

  else if test (count $argv) -gt 1
    set v $argv[1]
    echo "command line version $v"

  else if test -n $pkgversion
    set v $pkgversion
    echo "package version $pkgversion"

  else
    set v "latest"
    echo "stable version"

  end

  echo "using NODE version $v"

  if test (count $argv) -gt 1
    set s $argv[2]
    set args $argv[2..-1]

  else if test (count $argv) -gt 0
    set s $argv[1]
    set args $argv[1..-1]

  else
    set s ""
    set args $argv

  end

  mkdir -p .docker
  echo "$v" > .docker/node-version

  for e in (env);
    set environment -e "$e" $environment ;
  end

  echo "Launch NODEJS $v image $p-$s"
  docker run -it --rm --name "$p-$s" --net="host" $environment -v "$PWD":/usr/src/app -v /usr/include:/usr/include -v /usr/lib:/usr/lib -w /usr/src/app node:$v node $args ;
end



function npm.docker
  mkdir -p .docker

  set pkgversion (cat package.json | json engines.node | xargs semver-node --resolve)
  set cached_node_version (cat .docker/node-version)
  set p (echo $PWD | sed s/\\/// | sed s/\\//-/g);


  #echo "argv:" (count $argv)
  #echo (test (count $argv) -gt 1)
  if test -n $cached_node_version
    set v $cached_node_version
    set n 1
    echo "cached version $v"

  else if test (count $argv) -gt 1
    set v $argv[1]
    set n 2
    echo "command line version $v"

  else if test -n $pkgversion
    set v $pkgversion
    set n 1
    echo "package version $pkgversion"

  else
    set n 1
    set v "latest"
    echo "stable version"

  end

  mkdir -p .docker
  echo "$v" > .docker/node-version

  echo "using NODE version $v"

  for e in (env);
    set environment -e "$e" $environment ;
  end
  echo "Launch NPM from NODEJS $v image $p-$s"
  docker run -it --rm --name "$p-$s" $environment --net="host" -P -v "$PWD":/usr/src/app -w /usr/src/app node:$v npm $argv[$n..-1] ;
end


function rethinkdb.docker
  mkdir -p ".docker/rethinkdb"
  set p (echo $PWD | sed s/\\/// | sed s/\\//-/g)
  for e in (env);
    set environment -e "$e" $environment ;
  end
  echo "Launch RETHINKDB" $p
  docker run --name "$p-rethinkdb" $environment --net="host" -v "$PWD/.docker/rethinkdb:/data" -d rethinkdb
end


function es.docker
  mkdir -p ".docker/es"
  set p (echo $PWD | sed s/\\/// | sed s/\\//-/g)
  for e in (env);
    set environment -e "$e" $environment ;
  end

  echo "Launch ES" $p
  docker run --name "$p-es" $environment --net="host" -v "$PWD/.docker/es:/data" -d elasticsearch
end
