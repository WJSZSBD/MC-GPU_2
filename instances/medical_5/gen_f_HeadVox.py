import scipy.io as scio
import numpy as np
import os
import sys
import itk
import pandas as pd


def gen_vox_file(scale):

    # read map_MCGPU
    map_MCGPU = pd.read_excel('/mnt/520/haoshl/MC-GPU/vox/medical_5/data/f/map_MCGPU.xlsx')
    organ_id = map_MCGPU['Organ ID'].values
    material_id = map_MCGPU['MC_GPU Tissue ID'].values
    density = map_MCGPU['Density_2'].values
    material_map = dict(zip(organ_id, material_id))
    density_map = dict(zip(organ_id, density))


    # read Phantom data
    mat_file = '/mnt/520/haoshl/MC-GPU/vox/medical_5/data/f/headPhantom.mat'
    mat = scio.loadmat(mat_file)
    mat = mat['headPhantom']
    nx = mat.shape[0]
    ny = mat.shape[1]
    nz = mat.shape[2]
    dx = 0.1775*scale
    dy = 0.1775*scale
    dz = 0.4840*scale
    phantom = np.array(mat, dtype='float')

    phantom = phantom.flatten(order='F')  # 按列展开

    total_voxels = phantom.size


    # assign material
    f = open('/mnt/520/haoshl/MC-GPU/vox/medical_5/vox/f_head_scale'+str(scale)+'.vox', 'w')

    f.write('[SECTION VOXELS phantomER]\n')
    f.write(str(nx) + ' ' + str(ny) + ' ' + str(nz) + ' No. OF VOXELS IN X,Y,Z\n')
    f.write(str(dx) + ' ' + str(dy) + ' ' + str(dz) + ' VOXEL SIZE (cm) ALONG X,Y,Z\n')
    f.write('1 COLUMN NUMBER WHERE MATERIAL ID IS LOCATED\n')
    f.write('2 COLUMN NUMBER WHERE THE MASS DENSITY IS LOCATED\n')
    f.write('0 BLANK LINES AT END OF X,Y-CYCLES (1=YES,0=NO)\n')
    f.write('[END OF VXH SECTION]\n')

    for i in range(total_voxels):
        f.write(str(material_map[phantom[i]]) + ' ' + str(density_map[phantom[i]]) + '\n')

    f.close()


if __name__ == '__main__':
    scale = float(sys.argv[1])
    # scale = 1.0
    gen_vox_file(scale)
