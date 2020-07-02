library(tidyverse)
ggplot2::mpg
?mpg
ggplot(data=mpg)+
  geom_point(aes(x=displ,y=hwy))
#Exercise pg. 6
#1. Tabel mpg
#2. 234 rows & 11 columns
#3. Wheel drive categories
#4. Scatterplot of hwy vs cyl
ggplot (data=mpg)+
  geom_point(aes(x=hwy,y=cyl))
#5.1. Scatterplot of class vs drv
ggplot(data=mpg)+
  geom_point(aes(x=class,y=drv))
#5.2. Because both variable is categorical and do not have value to measured
#Aesthetic Mapping
ggplot(data=mpg)+
  geom_point(aes(x=displ,y=hwy,color=class))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,shape=class))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,size=class))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,alpha=class))
#Exercise pg. 12
#1. "blue" being read as variable not as coloring command
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,color="blue"))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy),color="blue") #write outside barrier to put coloring command to variable
#2.1. Categorical: manufacturer model, trans, drv, fl, class; Continuous: displ, year, cyl, cty, hwy.
#2.2. String data counted as categorical, scale data counted as continuous
#3. Continuous variable mapping
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,color=year))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,color=cyl))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,color=cty))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,size=year))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,size=cyl))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,size=cty))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,shape=year))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,shape=cyl))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,shape=cty))
#4. Mapping same variable on multiple aes
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,color=class,size=class))
#5. What stroke aesthetics do
?geom_point
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy),stroke=1)
#6. Map aesthetic to something other than variable name
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,color=displ<5))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy))+
  facet_wrap(~class,nrow=2)
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy))+
  facet_grid(drv~cyl)
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy,color=class))+
  facet_grid(drv~cyl)
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy))+
  facet_grid(.~cyl)
#Exercise pg. 15
#1. Facet on a continuous variable
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy))+
  facet_wrap(~cty,nrow=2)
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy))+
  facet_grid(.~cty)
# It is too much to be displayed
#2. Empty cells in facet_grid(drv~cyl)
ggplot(data=mpg)+
  geom_point(mapping=aes(x=drv,y=cyl))
#It means that there are no such car as 4wd with 5 cylinder, 
#and frontwd with 4 or 5 cylinder
#3. What . do
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy))+
  facet_grid(.~cyl)
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy))+
  facet_grid(drv~.)
#. may replace variable on row or column, and set it's value as 0
ggplot(data=mpg)+
  geom_smooth(mapping=aes(x=displ,y=hwy))
ggplot(data=mpg)+
  geom_smooth(mapping=aes(x=displ,y=hwy,linetype=drv))
ggplot(data=mpg)+
  geom_smooth(mapping=aes(x=displ,y=hwy,group=drv))
ggplot(data=mpg)+
  geom_smooth(mapping=aes(x=displ,y=hwy,color=drv),show.legend=FALSE)
ggplot(data=mpg,mapping=aes(x=displ,y=hwy))+
  geom_point()+
  geom_smooth()
ggplot(data=mpg,mapping=aes(x=displ,y=hwy))+
  geom_point(mapping=aes(color=class))+
  geom_smooth()
ggplot(data=mpg,mapping=aes(x=displ,y=hwy))+
  geom_point(mapping=aes(color=class))+
  geom_smooth(data=filter(mpg,class=="subcompact"),se=FALSE)
ggplot(data=mpg,mapping=aes(x=displ,y=hwy,color=drv))+
  geom_point()+
  geom_smooth(se=FALSE)

ggplot2::diamonds
ggplot(data=diamonds)+
  geom_bar(mapping=aes(x=cut))
ggplot(data=diamonds)+
  stat_count(mapping=aes(x=cut))
demo <- tribble(
  ~a, ~b,
  "bar_1", 20,
  "bar_2", 30,
  "bar_3", 40
)
ggplot(data=demo)+
  geom_bar(mapping=aes(x=a,y=b),stat="identity")
ggplot(data=diamonds)+
  geom_bar(mapping=aes(x=cut,y=..prop..,group=1))
ggplot(data=diamonds)+
  stat_summary(
    mapping=aes(x=cut,y=depth),
    fun.ymin=min,
    fun.ymax=max,
    fun.y=median
  )
ggplot(data=diamonds)+
  geom_col(mapping=aes(x=cut,y=price))
?stat_smooth
ggplot(data=diamonds)+
  stat_smooth(mapping=aes(x=carat,y=price))
ggplot(data=diamonds)+
  geom_bar(mapping=aes(x=cut,y=..prop..))
ggplot(data=diamonds)+
  geom_bar(mapping=aes(x=cut,fill=color,y=..prop..,group=1))

#Position Adjustment
#coloring bar chart
ggplot(data=diamonds)+
  geom_bar(mapping=aes(x=cut,color=cut))
ggplot(data=diamonds)+
  geom_bar(mapping=aes(x=cut,fill=cut))
#put variable to fill
ggplot(data=diamonds)+
  geom_bar(mapping=aes(x=cut,fill=clarity))
#adjust position="identity" to know exact position of each bar
ggplot(data=diamonds,mapping=aes(x=cut,fill=clarity))+
  geom_bar(alpha=1/5,position="identity")
ggplot(data=diamonds,mapping=aes(x=cut,color=clarity))+
  geom_bar(fill=NA,position="identity")
#adjust position="fill" to compare proportion across group
ggplot(data=diamonds)+
  geom_bar(mapping=aes(x=cut,fill=clarity),position="fill")
#adjust position="dodge" to compare individual value
ggplot(data=diamonds)+
  geom_bar(mapping=aes(x=cut,fill=clarity),position="dodge")
#adjust position="jitter" to see where the mass of the data
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ,y=hwy),position="jitter")

#exercise
ggplot(data=mpg,(mapping=aes(x=cty,y=hwy)))+
  geom_point()
ggplot(data=mpg,(mapping=aes(x=cty,y=hwy)))+
  geom_point(position="jitter")
ggplot(data=mpg,(mapping=aes(x=cty,y=hwy)))+
  geom_jitter()
ggplot(data=mpg,(mapping=aes(x=cty,y=hwy)))+
  geom_count()
ggplot(data=mpg,(mapping=aes(x=displ,y=hwy)))+
  geom_boxplot(aes(group=class))

#Coordinate System
#coord_flip to swtch x- and y-axis position
ggplot(data=mpg,mapping=aes(x=class,y=hwy))+
  geom_boxplot()
ggplot(data=mpg,mapping=aes(x=class,y=hwy))+
  geom_boxplot()+
  coord_flip()
#coord_quickmap to set aspect ratio for the map
install.packages("maps")
nz <- map_data("nz")
ggplot(nz,aes(long,lat,group=group))+
  geom_polygon(fill="white",color="black")
ggplot(nz,aes(long,lat,group=group))+
  geom_polygon(fill="white",color="black")+
  coord_quickmap()
#coord_polar to reveal connection between bar chart and Coxcomb chart
bar <- ggplot(data=diamonds)+
  geom_bar(
    mapping=aes(x=cut,fill=cut),
    show.legend=FALSE,
    width=1
  )+
  theme(aspect.ratio=1)+
  labs(x=NULL,y=NULL)
bar+coord_flip()
bar+coord_polar()
#exercise
install.packages("mapproj")
ggplot(nz,aes(long,lat,group=group))+
  geom_polygon(fill="white",color="black")+
  coord_map()
?coord_fixed
ggplot(data=mpg,mapping=aes(x=cty,y=hwy))+
  geom_point()+
  geom_abline()+
  coord_fixed()
#grammar of graphics
ggplot(data=<DATA>)+
  <GEOM_FUNCTION>(
    mapping=aes(<MAPPING>),
    stat=<STAT>,
    position=<POSITION>
  )+
  <COORDINATE_FUNCTION>+
  <FACET_FUNCTION>
  
#End of chapter