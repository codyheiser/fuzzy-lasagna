### fuzzy-lasagna
Spatial mapping of human kidney by automated structural segmentation and registration across paired IHC, AF, and IMS datasets

---
Download [QuPath](https://qupath.github.io/) for analysis of whole-slide IHC images. You will also need the [Bioformats Extension](https://github.com/qupath/qupath-bioformats-extension).  
QuPath scripts are found in `qupath_dev/`:  
* `.groovy` scripts run as QuPath macros
    * `Automate` > `Show Script Editor` > `File` > `Open...`
    * open script, then `Run`
* `.js` scripts are used in the ImageJ extension of QuPath
    * `Extensions` > `ImageJ` > `Export region to ImageJ`
    * in ImageJ: `Plugins` > `Macros` > `Run`

![summary](inputs/summary_fig.png)  
__Figure 1.__ Workflow and example output for automated MxIF segmentation using QuPath. __A)__ Whole-slide tiling workflow as implemented in javascript macro. Each tile of image is processed for watershed maxima and intensity threshold in a single channel; resulting ROIs returned as QuPath annotations. __B)__ Binary image mask outputs in three MxIF channels, highlighting unique macro structures in the tissue.

---
#### Python Implementation
```bash
pip install -r requirements.txt # make sure you have all necessary python packages
```
