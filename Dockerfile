FROM python:3.5

MAINTAINER Matvey Ezhov <matvey.ezhov@gmail.com>

# Python Data Science Lab in Docker

RUN apt-get update && apt-get install -y \
    build-essential g++ gfortran \
    libopenblas-dev \
    libopencv-dev \
    git

RUN curl https://bootstrap.pypa.io/get-pip.py | python

RUN pip install numpy
RUN pip install scipy
RUN pip install ipython nltk

RUN pip install --upgrade git+git://github.com/Theano/Theano.git
RUN pip install git+git://github.com/fchollet/keras.git

RUN python -c "import nltk; nltk.download('punkt')"

# MXNet
RUN cd /root && git clone --recursive https://github.com/dmlc/mxnet && cd mxnet && \
    cp make/config.mk config.mk && \
    sed -i 's/USE_BLAS = atlas/USE_BLAS = openblas/g' config.mk && \
    make -j"$(nproc)"
RUN cd /root/mxnet/python && python setup.py install

WORKDIR /lab

ENTRYPOINT bash
