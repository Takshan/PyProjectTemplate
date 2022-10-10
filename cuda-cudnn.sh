INSTALLDIR="/usr/local/cuda"
echo "${PACKAGE} ${VERSION} ${INSTALLDIR}"
echo "Installing CUDA and cuDNN"
echo "Installing CUDA"
cd ${INSTALLDIR}

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin 

sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /"
sudo apt-get update -y


sudo apt-get install libcudnn8=8.5.0.*-1+cuda11.7
# sudo apt-get install libcudnn8-dev=${cudnn_version}-1+${cuda_version}
sudo apt-get install libcudnn8-dev=8.5.0.*-1+cuda11.7
