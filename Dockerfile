FROM tensorflow/tensorflow:latest-py3-jupyter
LABEL maintainer="yakigac"

# OpencvはCで書かれていてビルドが必要．
# そのためにgcc(GNU Compiler Collectionの略．C, Java, Fortran等の複数の言語に対応したコンパイラー.)や
# wget(curlのような働き)をインストールする必要がある．
RUN apt-get update -y && apt-get install -yq make cmake gcc g++ unzip wget build-essential gcc zlib1g-dev

RUN apt-get install -y libsm6 libxext6 libxrender-dev

# Opencvのインストール
## lnコマンドはリンク（ショートカット）を作成する．.
RUN ln -s /usr/include/libv4l1-videodev.h /usr/include/linux/videodev.h

RUN mkdir ~/tmp
RUN cd ~/tmp && wget https://github.com/Itseez/opencv/archive/3.1.0.zip && unzip 3.1.0.zip
RUN cd ~/tmp/opencv-3.1.0 && cmake CMakeLists.txt -DWITH_TBB=ON \
                                                  -DINSTALL_CREATE_DISTRIB=ON \
                                                  -DWITH_FFMPEG=OFF \
                                                  -DWITH_IPP=OFF \
                                                  -DCMAKE_INSTALL_PREFIX=/usr/local
RUN cd ~/tmp/opencv-3.1.0 && make -j2 && make install

# jupyterlab拡張機能の為のnodejsとnpmのインストール．
RUN apt-get install -y nodejs npm

# pipでインストールするライブラリを記載．
RUN pip install --upgrade pip && \
    pip install \
      keras \
      pandas \
      numpy \
      matplotlib \
      seaborn \
      scikit-learn \
      plotly \
      jupyterlab \
      opencv-python

RUN jupyter labextension install @jupyterlab/toc
# Install system packages

#RUN apt-get update && apt-get install -y --no-install-recommends \
    #wget  \
    #rm -rf /var/lib/apt/lists/*

# Install conda
#ENV CONDA_DIR /conda
#ENV PATH $CONDA_DIR/bin:$PATH

#RUN wget --quiet --no-check-certificate https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh && \
#    echo "c59b3dd3cad550ac7596e0d599b91e75d88826db132e4146030ef471bb434e9a *Miniconda3-4.2.12-Linux-x86_64.sh" | sha256sum -c - && \
#    /bin/bash /Miniconda3-4.2.12-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
#    rm Miniconda3-4.2.12-Linux-x86_64.sh && \
#    echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh

#RUN conda config --append channels conda-forge

#RUN conda install -y python=${python_version} && \
    #pip install --upgrade pip && \
    #pip install \
    #  sklearn_pandas \
    #  tensorflow-gpu==1.12 && \

    #conda install \
    #  bcolz \
    #  h5py \
    #  matplotlib \
    #  mkl \
    #  nose \
    #  notebook \
    #  Pillow \
    #  pandas \
    #  pydot \
    #  pygpu \
    #  pyyaml \
    #  scikit-learn \
    #  six \
    #  mkdocs \
    #  && \
    #git clone git://github.com/keras-team/keras.git /src && pip install -e /src[tests] && \
    #pip install git+git://github.com/keras-team/keras.git && \
    #conda clean -yt

#ENV LC_ALL=C.UTF-8
#ENV LANG=C.UTF-8

#ENV PYTHONPATH='/src/:$PYTHONPATH'

# WORKDIR /home/nakatsuka

#EXPOSE 8880

#CMD jupyter notebook --port=8880 --ip=0.0.0.0 --allow-root
