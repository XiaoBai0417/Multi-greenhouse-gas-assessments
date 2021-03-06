# -*- coding: utf-8 -*-
# ---------------------------------------------------------------------------
# extractB.py
# Created on:  2020-06-05
#   (generated by ArcGIS\ModelBuilder)
# Description: zonal extract sum on country/continent level, covert table to excel 
# Copyright (C) 2020-2022 Ziyu LIN
# ---------------------------------------------------------------------------

# Import arcpy module
import arcpy
import os


CountryLayer = 'F:\junyu\zonal\WorldCountries247_prj.shp'
arcpy.MakeFeatureLayer_management(CountryLayer, 'CountryLayer')
ContinentLayer = 'F:\junyu\zonal\continent_prj.shp'
arcpy.MakeFeatureLayer_management(ContinentLayer, 'ContinentLayer')


for wetland_type in range(1,13):
	for temp_type in range(1,4):
		wetland_carbon1 = "F:\junyu\zonal\\result\c1_wet{}_temp{}.tif".format(wetland_type,temp_type)
		wetland_carbon2 ="F:\junyu\zonal\\result\c2_wet{}_temp{}.tif".format(wetland_type,temp_type)
		# arcpy.gp.RasterCalculator_sa('SetNull("F:\junyu\zonal\\result\wet_temp{}_prj.tif"!= {}, "F:\junyu\OCSTHA_M_100cm_1km_ll\OCSTHA_M_100cm_1km_ll.tif")'.format(temp_type,wetland_type,temp_type), wetland_carbon1)
		# arcpy.gp.RasterCalculator_sa('SetNull("F:\junyu\zonal\\result\wet_temp{}_prj.tif"!= {}, "F:\junyu\OCSTHA_M_100cm_1km_ll\OCSTHA_M_200cm_1km_ll.tif")'.format(temp_type,wetland_type,temp_type), wetland_carbon2)
		contry_table1 = 'F:\junyu\zonal\\result\carbon_country_wet{}_temp{}_1.dbf'.format(wetland_type,temp_type)
		continent_table1 = 'F:\junyu\zonal\\result\carbon_continent_wet{}_temp{}_1.dbf'.format(wetland_type,temp_type)
		country_TableToExcel_xls1 = 'F:\junyu\zonal\\result\carbon_country_wet{}_temp{}_1.xls'.format(wetland_type,temp_type)
		continent_TableToExcel_xls1 = 'F:\junyu\zonal\\result\carbon_continent_wet{}_temp{}_1.xls'.format(wetland_type,temp_type)
		contry_table2 = 'F:\junyu\zonal\\result\carbon_country_wet{}_temp{}_2.dbf'.format(wetland_type,temp_type)
		continent_table2 = 'F:\junyu\zonal\\result\carbon_continent_wet{}_temp{}_2.dbf'.format(wetland_type,temp_type)
		country_TableToExcel_xls2 = 'F:\junyu\zonal\\result\carbon_country_wet{}_temp{}_2.xls'.format(wetland_type,temp_type)
		continent_TableToExcel_xls2 = 'F:\junyu\zonal\\result\carbon_continent_wet{}_temp{}_2.xls'.format(wetland_type,temp_type)
		
		#Process: Zonal Statistics as Table
		arcpy.gp.ZonalStatisticsAsTable_sa(CountryLayer, "NAME", wetland_carbon1, contry_table1, "DATA", "ALL")
		arcpy.gp.ZonalStatisticsAsTable_sa(ContinentLayer, "CONTINENT", wetland_carbon1, continent_table1, "DATA", "ALL")
		arcpy.gp.ZonalStatisticsAsTable_sa(CountryLayer, "NAME", wetland_carbon2, contry_table2, "DATA", "ALL")
		arcpy.gp.ZonalStatisticsAsTable_sa(ContinentLayer, "CONTINENT", wetland_carbon2, continent_table2, "DATA", "ALL")


		arcpy.MakeTableView_management(contry_table1, 'contry_table{}{}_1'.format(wetland_type,temp_type))
		arcpy.MakeTableView_management(continent_table1, 'continent_table{}{}_1'.format(wetland_type,temp_type))
		arcpy.MakeTableView_management(contry_table2, 'contry_table{}{}_2'.format(wetland_type, temp_type))
		arcpy.MakeTableView_management(continent_table2, 'continent_table{}{}_2'.format(wetland_type, temp_type))
		# Process: Table To Excel
		arcpy.TableToExcel_conversion('contry_table{}{}_1'.format(wetland_type,temp_type), country_TableToExcel_xls1, "ALIAS", "CODE")
		arcpy.TableToExcel_conversion('continent_table{}{}_1'.format(wetland_type,temp_type), continent_TableToExcel_xls1, "ALIAS", "CODE")
		arcpy.TableToExcel_conversion('contry_table{}{}_2'.format(wetland_type,temp_type), country_TableToExcel_xls2, "ALIAS", "CODE")
		arcpy.TableToExcel_conversion('continent_table{}{}_2'.format(wetland_type,temp_type), continent_TableToExcel_xls2, "ALIAS", "CODE")


