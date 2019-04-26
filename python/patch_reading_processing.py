import numpy as np
from openslide import open_slide
from openslide.deepzoom import DeepZoomGenerator
from xml.dom import minidom
from shapely.geometry import Polygon, Point, box
import pandas as pd

#this function is for preparing data for deep learning
#probably not relevant for segmentation workflow
def check_label_exists(label, label_map):
    ''' Checking if a label is a valid label.
    '''
    if label in label_map:
        return True
    else:
        print("py_wsi error: provided label " + str(label) + " not present in label map.")
        print("Setting label as -1 for UNRECOGNISED LABEL.")
        print(label_map)
        return False

#this function is for preparing data for deep learning
#probably not relevant for segmentation workflow
def generate_label(regions, region_labels, point, label_map, object_detection = True):
    ''' Generates a label given an array of regions.
        - regions               array of vertices
        - region_labels         corresponding labels for the regions
        - point                 x, y tuple
        - label_map             the label dictionary mapping string labels to integer labels
    '''
    if object_detection == True:
        patch_xy = point[0]
        patch_lw = point[1]
        patch_dim = (patch_xy[0] + patch_lw[0], patch_xy[1] + patch_lw[1])

        patch_poly = box(patch_xy[0],patch_xy[1],patch_dim[0],patch_dim[1])

        annotation_in_patch = []
        annotation_label = []
        for idx,annotation in enumerate(regions):
            roi = Polygon(annotation)
            in_patch = patch_poly.contains(roi)
            if in_patch == True:
                annotation_relative = np.column_stack((annotation[:,0] - patch_xy[0],
                                               annotation[:,1] - patch_xy[1]))
                annotation_in_patch.append(annotation_relative)
                annotation_label.append(region_labels[idx])

        if len(annotation_in_patch) > 0:
            return annotation_in_patch, annotation_label
        else:
            return -1

    else:
        for i in range(len(region_labels)):
            poly = Polygon(regions[i])
            if poly.contains(Point(point[0], point[1])):
                return region_labels[i]
            else:
                return -1


    # By default, we set to "Normal" if it exists in the label map.
    # if check_label_exists('Normal', label_map):
    #     return label_map['Normal']
    # else:
    #     return -1

#this function is for preparing data for deep learning
#probably not relevant for segmentation workflow
def get_regions(path, type='qupath'):
    ''' Parses the xml at the given path, assuming annotation format importable by ImageScope. '''
    if type == 'qupath':
        polys = pd.read_table(path, sep='#',header=None)

        polys[1] = polys[1].map(lambda x: x.lstrip('[').rstrip(']'))
        polys[1] = polys[1].map(lambda x: x.replace('Point: ',''))

        regions = []
        for row in range(len(polys)):
            poly_array = np.asarray(polys[1][row].split(', '), dtype=np.float64)
            nrow = len(poly_array) / 2
            poly_array = np.reshape(poly_array, [int(nrow),2])
            poly_array = poly_array.round(0).astype(np.uint32)
            #poly_array = np.flip(poly_array,axis=1)
            regions.append(poly_array)

        region_labels = polys[0].tolist()

        return regions, region_labels

    elif type =='xml':

        xml = minidom.parse(path)
        # The first region marked is always the tumour delineation
        regions_ = xml.getElementsByTagName("Region")
        regions, region_labels = [], []
        for region in regions_:
            vertices = region.getElementsByTagName("Vertex")
            attribute = region.getElementsByTagName("Attribute")
            if len(attribute) > 0:
                r_label = attribute[0].attributes['Value'].value
            else:
                r_label = region.getAttribute('Text')
            region_labels.append(r_label)

            # Store x, y coordinates into a 2D array in format [x1, y1], [x2, y2], ...
            coords = np.zeros((len(vertices), 2))

            for i, vertex in enumerate(vertices):
                coords[i][0] = vertex.attributes['X'].value
                coords[i][1] = vertex.attributes['Y'].value

            regions.append(coords)
            return regions, region_labels


#these are relevant to segmentation
def patch_to_tile_size(patch_size, overlap):
    return patch_size - overlap*2

#these are relevant to segmentation
def sample_and_store_patches(file_name,
                             file_dir,
                             pixel_overlap,
                             patch_size=512,
                             region_path=None,
                             label_map={},
                             limit_bounds=True,
                             object_detection = True):

    ''' Sample patches of specified size from .svs file.
        - file_name             name of whole slide image to sample from
        - file_dir              directory file is located in
        - pixel_overlap         pixels overlap on each side
        - label_map             dictionary mapping string labels to integers
        - object_detection      boolean - whether the patches are extracted for object detection
        Note: patch_size is the dimension of the sampled patches, NOT equivalent to openslide's definition
        of tile_size. This implementation was chosen to allow for more intuitive usage.
    '''

    tile_size = patch_to_tile_size(patch_size, pixel_overlap)

    slide = open_slide(file_dir + file_name)

    tiles = DeepZoomGenerator(slide,
                              tile_size=tile_size,
                              overlap=pixel_overlap,
                              limit_bounds=limit_bounds)

    #should't need this
    if region_path:
        # Expect filename of XML annotations to match SVS file name
        regions, region_labels = get_regions(region_path)

    #always used the most resolved level
    level = tiles.level_count - 1

    #get number of tiles for iterating
    x_tiles, y_tiles = tiles.level_tiles[level]

    #initialize the while loop with these values
    x, y = 0, 0
    count = 0
    
    #create lists where the data will go
    patches, coords, labels, relative_polys = [], [], [], []
    while y < y_tiles:
        while x < x_tiles:
            #object detection is an argument added for the generate label
            #you will probably need to strip this out and go directly to patch processing below
            if object_detection == True:
                patch_dims = [tiles.get_tile_coordinates(level, (x, y))[0],
                              tiles.get_tile_coordinates(level, (x, y))[2]]
                label = generate_label(regions, region_labels, patch_dims, label_map, object_detection = object_detection)
                
            #without object detection is just extracts patches within a polygon
            else:
                converted_coords = tiles.get_tile_coordinates(level, (x, y))[0]
                label = generate_label(regions, region_labels, converted_coords, label_map)

            if label != -1:
                ##the line below is how the patch is read into numpy
                new_tile = np.array(tiles.get_tile(level, (x,y)), dtype=np.uint8)
                #the offsets are defined in patch_dims above using tiles.get_tile_coordinates(level, (x, y))[0]
                ##this is where you would then process the patch for segmentation


                #you wouldn't need to keep the patch though which is what the line below does,
                #as basically this would keep
                #the image data loaded into memory, we just want the segmentation from
                #each image kept, see below
                patches.append(new_tile)

                ##Read Me##
                #this is the where the patch and its segmentation data is added to the python list
                #in my case I use the polygon coordinates relative to the patch,
                #i.e. if the patch of dimension 1024x1024 starts at offset (x,y)(3000,3000)
                #the polygon would be still have coordinates between 0 and 1024 in x and y
                #in the segmentation case it will be necessary to add the offset back to the polygon coordinates
                #after they are detected
                #This way, we know WHERE the polygon is in the original microscopy coordinates
                #this will allow us to load them into QuPath later for visualization
                #the offsets are defined in patch_dims above using tiles.get_tile_coordinates(level, (x, y))[0]
                coords.append(np.array([x, y]))
                relative_polys.append(label[0])
                labels.append(label[1])
                count += 1

        #these are the count iterators that pass through the whole slide image..
            x += 1
        y += 1
        x = 0

    return patches, coords, labels, relative_polys


#example usage of how I use this,
#you will need to modify the guts of this to process your image data once the patch is sampled
sample_and_store_patches(file_name, #file name within the file_dir below
                         file_dir, #directory where the above file is foound
                         pixel_overlap, #amount of pixel overlap should be patch_size / 4 for half-window overlap
                         patch_size=512, #size of the x and y dimension of the patch in pixels 512 or 1024 are good
                         region_path=None, #for preparing data, not relevant to segmentation
                         label_map={}, #for preparing data, not relevant to segmentation
                         limit_bounds=True, #leave this true
                         object_detection=True)
