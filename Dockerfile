# FROM nvcr.io/nvidia/tensorflow:22.08-tf2-py3
# FROM gcr.io/deeplearning-platform-release/tf-gpu.2-10
# use base cuda and install python 3.10
# FROM nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu22.04
FROM tensorflow/tensorflow:latest-gpu


## INstall system dependencies
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git g++ wget   && \
	apt-get install -y build-essential libssl-dev 
RUN apt-get update && apt-get upgrade -y	
RUN apt-get install -y  cmake python3-pip
#RUN apt-get purge --auto-remove python -y 
RUN apt-get update && apt-get install -y python3.10 
# COPY . /app

## SOME ENVIRONMENT VARIABLES
ENV DEBIAN_FRONTEND=noninteractive
ENV TF_ENABLE_ONEDNN_OPTS=0
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility


RUN apt-get -y update
RUN ln -s /usr/bin/python3 /usr/bin/python 
# RUN ln -s /usr/bin/pip3 /usr/bin/pip


# Openbabel installation
RUN apt-get install -y libopenbabel-dev
RUN wget --quiet https://github.com/openbabel/openbabel/releases/download/openbabel-3-1-1/openbabel-3.1.1-source.tar.bz2 -O openabel.tar.bz2 && \
	tar -xjf openabel.tar.bz2 && \
	cd openbabel-3.1.1 && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make -j4 && \
	make install && \
	cd ../.. && \
	rm -rf openbabel-3.1.1



# conda installation
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

RUN conda create --name py10 python=3.10
RUN conda init bash

RUN echo "conda activate py10" > ~/.bashrc

ENV CONDA_DEFAULT_ENV py10
SHELL ["conda", "run", "-n", "py10", "/bin/bash", "-c"]


RUN conda install -c conda-forge openbabel

# RUN conda activate py10

ENV PATH /opt/conda/envs/py10/bin:$PATH


COPY requirements.txt /home/app/requirements.txt
RUN pip install -r /home/app/requirements.txt
#COPY /home/takshan/.gitconfig /home/.gitconfig


RUN apt-get update && apt-get upgrade -y
RUN ln -snf /bin/bash /bin/sh
RUN "echo 0 | tee -a /sys/bus/pci/devices/0000\:01\:00.0/numa_node"

RUN useradd takshan
USER takshan

CMD ["tail", "-f", "/dev/null"]
