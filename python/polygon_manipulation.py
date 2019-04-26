import numpy as np
import pandas as pd
from shapely import geometry
from shapely import ops

def intersect_polygons(poly, boundary, threshold):
    #poly is a polygon
    #boundary is another polygon we are testing against for overlap
    #threshold is a number between 0 and 1 for the degree of overlap
    if poly.overlaps(boundary) == True:
        intersection_area = (boundary.intersection(poly).area / boundary.area) * 100
        union_area = (boundary.union(poly).area / boundary.area) * 100

        #we return a T/F here on whether a polygon has enough overlap
        #intersection over union is AKA Jaccard Index
        #https://stackoverflow.com/questions/28723670/intersection-over-union-between-two-detections
        #some discussion in the link above
        return (intersection_area / union_area) > threshold
    else:
        return False


##I'll comment this one later!
def reduce_polygons(all_detections, IoU_threshold = 0.3):

    all_detections_uniques = all_detections.groupby('patchname_maskidx')
    unique_polys = all_detections.patchname_maskidx.unique()
    unique_scores = all_detections.label.unique()

    uniques = unique_polys.tolist()


    polygons = []
    for poly in uniques:
        polygons.append(geometry.Polygon(np.asarray(all_detections_uniques.get_group(poly)[['x','y']])))

    union_polys = []


    while len(polygons[:]) > 0:
        #print(str(count) + "_" +uniques[count] +'_'+str(len(polygons)))
        test_poly = polygons[0]

        intersects = [intersect_polygons(p, test_poly,IoU_threshold) for p in polygons]
        intersecting_polygons = np.where(np.asarray(intersects) == True)[0].tolist()
        if len(intersecting_polygons) > 0:
            unique_name = uniques[0]
            indices = [0] + intersecting_polygons

            merge_polys = []
            for i in sorted(indices,reverse=True):
                merge_polys.append(polygons[i])
                polygons.remove(polygons[i])
                uniques.remove(uniques[i])
    ##        for i in sorted(indices, reverse=True):
    ##            polygons.remove(merge_polys)

            merge_polygon = ops.cascaded_union(merge_polys)
        else:
            merge_polygon = test_poly
            polygons.remove(polygons[0])
            unique_name = uniques[0]
            uniques.remove(uniques[0])

        x, y = merge_polygon.exterior.coords.xy
        save_poly = np.column_stack([x,y]).astype(np.int32)
        #save_poly = np.array2string(save_poly,separator = ',').replace('\n', '').replace('[[', '[').replace(']]',']')

        x_pts = np.array2string(np.asarray(x).astype(np.int32),separator=',').replace('\n', '').replace('[', '').replace(']','')
        y_pts = np.array2string(np.asarray(y).astype(np.int32),separator=',').replace('\n', '').replace('[', '').replace(']','')

        union_polys.append(pd.DataFrame({'index':[1],'label':['Glomerulus'],'patchname_maskidx':[unique_name],'x_pts':[x_pts],'y_pts':[y_pts]}))

    return pd.concat(union_polys)
