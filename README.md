# Nonnegative-Constrained Joint Collaborative Representation with Union Dictionary for Hyperspectral Anomaly Detection

This is a demo of this work implemented in Matlab, written by Shizhen Chang and [Pedram Ghamisi](https://www.pedram-ghamisi.com/).

![](Figure/flowchart.pdf)

For more details, please refer to our paper: [Nonnegative-Constrained Joint Collaborative Representation With Union Dictionary for Hyperspectral Anomaly Detection](https://ieeexplore.ieee.org/document/9845465)

## Environment and package:
* Matlab R2015b
* [Ncut](http://timotheecour.com/software/ncut/ncut.html)

## Files
This package contains the following files and directories.
* [demo.m](demo.m): A demo shows how to run this work.
* [NJCR.m](NJCR.m): Implementation of the NJCR model.
* [KNJCR.m](KNJCR.m): Implementation of the KNJCR model.
* [/utils/](/utils/): Supportive files of this work.

## Usage
* After unzipping the files, put the current directory of Matlab to `mydir`.
* Add the directory path for the dependencies files.
```
addpath('./utils')
addpath('./Ncut_9/');
```
* Run `demo.m`.
## Citation
Please cite our paper if you find it useful for your research.
```
@article{chang2022Nonnegative,
  author={Chang, Shizhen and Ghamisi, Pedram},
  journal={IEEE Transactions on Geoscience and Remote Sensing}, 
  title={Nonnegative-Constrained Joint Collaborative Representation With Union Dictionary for Hyperspectral Anomaly Detection}, 
  year={2022},
  volume={60},
  number={},
  pages={1-13},
  doi={10.1109/TGRS.2022.3195339}}

```

## Acknowledgment
The authors would like to express their thanks to the authors and the creators of [Ncut](http://timotheecour.com/software/ncut/ncut.html) and cluster_dp for releasing their packages.

Please note that if implementing the `Ncut_9` in Matlab R2015b, the 81st line of ncut.m should be modified to:

```
[vbar,s,convergence] = eigs(@mex_w_times_x_symmetric,size(P,1),nbEigenValues,'LA',options,tril(P)); 
```
## Notice
This demo is distributed under [MIT License](LICENSE) and is released for scientific purposes only.
