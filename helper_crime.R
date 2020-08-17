library(arcgisbinding)
library(sp)
library(spdep)

arc.check_product()

enrich_df <- arc.open(path = 'C:/Users/benjamcr/Rproj/GEOG2015/CrimeDat/SF_Crime.gdb/San_Francisco_Crimes_Enrich_Subset')


enrich_select_df <- arc.select(object = enrich_df, fields = c('OBJECTID', 'SUM_VALUE', 'historicalpopulation_tspop10_cy', 'wealth_medval_cy', 'wealth_medhinc_cy', 'ownerrenter_renter_cy', 'businesses_n13_bus', 'businesses_n37_bus'))
enrich_sp <- arc.data2sp(enrich_select_df)


col_names <- c("OBJECTID", "Crime_Counts",
               "Population", "Med_HomeValue", "Med_HomeIncome",
               "Renter_Count", "Grocery",
               "Restaurant")

# Replace the colnames of enrich_sp by the ones you specified above
colnames(enrich_sp@data) <- col_names

# Check if the change has been made:
head(enrich_sp@data)

n <- enrich_sp@data$Crime_Counts
x <- enrich_sp@data$Population
EB <- EBest (n, x)
p <- EB$raw
b <- attr(EB, "parameters")$b
a <- attr(EB, "parameters")$a
v <- a + (b/x)
v[v < 0] <- b/x
z <- (p - b)/sqrt(v)

enrich_sp@data$EB_Rate <- z

arcgis_df <- arc.sp2data(enrich_sp)
arc.write('C:/Users/benjamcr/Rproj/GEOG2015/CrimeDat/SF_Crime.gdb/San_Francisco_Crime_Rates', arcgis_df, 
          shape_info = arc.shapeinfo(enrich_df))
