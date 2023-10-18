#imports
library(countcolors)
print("Hello World!!!")
library(scatterplot3d)
library(imager)



# typical RGB values range between 0 and 255, but R scales them to range between
# 0 and 1, where 1 is maximum brightness

#defining RGB boundaries by creating a center
#later, the radii from the RGB points will be defined to create a spherical color space
#two spheres are created to better capture the pixels indicating vegetation
center.spherical <- c(0.5581260960, 0.68501913, 0.17267655)
center1.spherical <- c(0.1947635184, 0.50021722, 0.01559939)


#defines path to image
#typically, this will take the format of "[path/to/directory]/image_name.jpeg"
image.name <- "/Users/kevinyuan/oldR/Mariposa.jpg"

#stores and loads image into a variable
file <- load.image(image.name)
#plots image on a Cartesian plane
plot(file)

#specifies RGB triplets to ignore when counting colored pixels in an image
#here, a primarily blue color space is enclosed, to factor out water area
a <- c(0.2, 0.2, 0.45)
b <- c(0, 0, 0)



#plots pixels with RBG coordinates
#n indicates amount of points created on graph
colordistance::plotPixels('/Users/kevinyuan/oldR/Mariposa.jpg', lower = NULL, upper = NULL, n = 10000,  color.space = "rgb")





#uses K-means clustering to find n number of color clusters
kmeans.clusters <- colordistance::getKMeanColors('/Users/kevinyuan/oldR/Mariposa.jpg', n = 100, plotting = TRUE)

#prints rgb triplets and sizes representing clusters
colordistance::extractClusters(kmeans.clusters, ordering = TRUE)



#reads image into environment
map <- jpeg::readJPEG('/Users/kevinyuan/oldR/Mod2.jpg')


#identifies and changes target pixels to magenta
#magenta is used in this exploration, since it would not appear on the map prior to the countColors function
countcolors::changePixelColor(map, map.spherical$pixel.idx, target.color="magenta")


#counts pixels in color range(s) within defined radii, excluding a range of color to be ignored
#and changes counted pixels to a color(s)
#plots the map with the color change
#rgb radius extended from spherical center
two.colors <- countcolors::countColors('/Users/kevinyuan/oldR/Mod2.jpg', color.range="spherical", 
                                       center = c(center.spherical, center1.spherical), radius = c(0.11, 0.175),
                                       bg.lower=b, bg.upper=a, plotting = TRUE,
                                       target.color=c("magenta", "cyan"))


#prints the fraction of the image with the selected coloration
#excluding the color space defined by bg.lower and bg.upper
two.colors$pixel.fraction


#countColorsInDirectory is a wrapper for countColors
#it returns both images with modified pixels and pixel.fraction values
#radius was approximated with trial and error
final <- countColorsInDirectory('/Users/kevinyuan/oldR/Mod2.jpg', color.range = "spherical", 
                                center = c(center.spherical, center1.spherical), radius = c(0.11, 0.175),
                                bg.lower=b, bg.upper=a, target.color=c("magenta"), 
                                plotting = FALSE, save.indicator = TRUE, dpi = 72, return.indicator = FALSE)

#loops through and prints elements of the final array
for (val in 1:21){
  print(final[val])
}
