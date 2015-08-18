#! /bin/sh
package="pokerthacc"
version="-1.0-1"
rm -rf ./tmp
cp -a "$package""$version".debpackage ./tmp
if [ -d ./tmp ]; then
  echo "./tmp dir exists so continue \n"
  cd ./tmp
  echo "remove .git files \n"
  find . | grep .git | xargs rm -rf
  cd ..
  fakeroot dpkg-deb --build tmp
  mv ./tmp.deb "$package""$version".deb
  rm -rf ./tmp
else
  echo " ./tmp directory does not exist so skip make \n"
fi

