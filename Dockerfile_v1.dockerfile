# 本镜像完全复刻作者的环境。（参考https://github.com/notiom/ER-nerf）
# https://hub.docker.com/r/nvidia/cuda/tags?page=&page_size=&ordering=&name=
ARG BASE_IMAGE=nvcr.io/nvidia/cuda:11.6.1-cudnn8-devel-ubuntu20.04
FROM cs_v1:0.04

# LABEL repository="cs_v1" python="3.10" 

# # 设置环境变量，防止交互提示
# ENV DEBIAN_FRONTEND=noninteractive

# # 安装必要的工具
# RUN apt-get update -yq --fix-missing && apt-get install -yq --no-install-recommends \
#     pkg-config \
#     wget \
#     cmake \
#     curl \
#     bzip2 \
#     git \
#     vim \
#     ca-certificates \
#     libgl1-mesa-glx \
#     && apt-get clean

# RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
# /bin/bash ~/miniconda.sh -b -p /root/miniconda && \
# rm ~/miniconda.sh

# # 设置环境变量
# ENV PATH /root/miniconda/bin:$PATH

# # 初始化 Conda
# RUN conda init bash

# # 创建并激活 Python 3.10 环境 & 验证
# RUN conda create -n py310 python=3.10 -y && conda clean -a -y && python -V

# # 设置容器启动时默认进入 Python 3.10 环境
# RUN echo "conda activate py310" >> ~/.bashrc

# ## 以上为基础环境 cs_v1:base

# # 1.使用conda安装cuda环境，这里不能使用conda安装torch，conda默认安装torch+cpu
# RUN conda install cudatoolkit=11.3 -c pytorch -y

# # 2.使用pip安装；报找不到，实际是能找到的。先install 远程路径 build时异常；我处理为自己下载映射到容器内安装成功。(也可以下载到容器内安装)
#RUN pip install torch==1.12.1+cu113 torchvision==0.13.1+cu113 --extra-index-url https://download.pytorch.org/whl/cu113

# # 3. 复制项目
# COPY . /home
# WORKDIR /home/nerfstream
# RUN pip install -r requirements.txt

# # 4.安装pytorch3d，# 需要先安装fvcore，否则pytorch3d找不到fvcore
# RUN pip install fvcore 
# # build构建时还是提示找不到合适的版本。只能进入容器内安装。
# RUN pip install --no-index --no-cache-dir pytorch3d -f https://dl.fbaipublicfiles.com/pytorch3d/packaging/wheels/py310_cu113_pyt1121/download.html

# 5.安装tensorflow-gpu==2.8.0
RUN pip install tensorflow-gpu==2.8.0

# 启动命令
CMD ["/bin/bash"]