set -ex

mkdir -p $HOME/.stack/global-project
cp .github/stack/stack.yaml $HOME/.stack/global-project

pushd $HOME
stack config set resolver ghc-8.6.5
popd

# conda activate test
# which python
# Adjust PATH in macOS because conda is not at front of it
export PATH=/usr/local/miniconda/envs/test/bin:/usr/local/miniconda/condabin:$PATH
GHC_LIB=$(stack exec -- ghc --print-libdir)
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$GHC_LIB/rts:$(pwd)/ext_lib

for dir in $GHC_LIB/*/; do
    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$dir
done

# python setup.py bdist_wheel
python packaging/build_wheels.py

if [[ $PYTHON_VERSION == "3.8" ]]; then
    python setup.py sdist
fi
