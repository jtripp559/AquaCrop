# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set environment variables to avoid user interaction during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    gfortran \
    make \
    wget \
    fp-compiler \
    && apt-get clean

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /miniconda.sh && \
    bash /miniconda.sh -b -p /opt/conda && \
    rm /miniconda.sh

# Add conda to PATH
ENV PATH=/opt/conda/bin:$PATH

# Initialize conda
RUN /opt/conda/bin/conda init bash

# Create a conda environment with Python 3.9 and the required libraries
RUN /bin/bash -c "source /opt/conda/etc/profile.d/conda.sh && \
    conda create -y --name dev_3.9 python=3.9 && \
    conda activate dev_3.9 && \
    conda install -y csvkit pathlib python-dotenv pandas"

# Create a conda environment with Python 3.9 and the required libraries
# RUN conda create -y --name dev_3.9 python=3.9 && \
#    /opt/conda/bin/conda install -y -n dev_3.9 csvkit pathlib

# Activate the conda environment
# RUN conda activate dev_3.9
# SHELL ["conda", "run", "-n", "dev_3.9", "/bin/bash", "-c"]

# Set the working directory
WORKDIR /AquaCrop

# Copy the current directory contents into the container at /AquaCrop
COPY . /AquaCrop

# Build the Fortran code
WORKDIR /AquaCrop/src
# RUN make
# RUN /bin/bash -c "make"
RUN /bin/bash -c "source /opt/conda/etc/profile.d/conda.sh && conda activate dev_3.9 && make clean && make"

# Ensure the aquacrop executable is in the correct location
# RUN cp /AquaCrop/src/aquacrop /AquaCrop/aquacrop

# Set the working directory back to /AquaCrop
WORKDIR /AquaCrop

# Set the default command to run the Fortran executable
# WORKDIR /AquaCrop
# CMD ["./aquacrop"]

# Set the default command to run the generate_pro_file.py script
# CMD ["/bin/bash", "-c", "source /opt/conda/etc/profile.d/conda.sh && conda activate dev_3.9 && python nbs/generate_pro_file.py"]


# cd /AquaCrop/src
# make clean
# make
# /opt/conda/envs/dev_3.9/bin/python3 /AquaCrop/nbs/generate_pro_file.py