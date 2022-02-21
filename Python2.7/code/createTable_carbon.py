# -*- coding: utf-8 -*-
# ---------------------------------------------------------------------------
# createResult.py
# Created on: 2020-06-05
# Description: wrap up all the tables into one csv file
# Copyright (C) 2020-2022 Ziyu LIN
# ---------------------------------------------------------------------------


import os
import pandas as pd
country_name = pd.read_csv('F:\junyu\zonal\\result\country_name.csv')
continent_name = pd.read_csv('F:\junyu\zonal\\result\continent_name.csv')
for carbon_type in range(1, 3):
    for wetland_type in range(1,13):
        for temp_type in range(1,4):
            country_TableToExcel_xls = 'F:\junyu\zonal\\result\carbon_country_wet{}_temp{}_{}.xls'.format(wetland_type, temp_type,carbon_type)
            continent_TableToExcel_xls = 'F:\junyu\zonal\\result\carbon_continent_wet{}_temp{}_{}.xls'.format(wetland_type, temp_type,carbon_type)
            country = pd.read_excel(country_TableToExcel_xls)
            continent = pd.read_excel(continent_TableToExcel_xls)
            sum_name = 'SUM_W{}_T{}_C{}'.format(wetland_type, temp_type,carbon_type)
            mean_name = 'MEAN_W{}_T{}_C{}'.format(wetland_type, temp_type,carbon_type)
            country[sum_name] = country['SUM']
            continent[sum_name] = continent['SUM']
            country[mean_name] = country['MEAN']
            continent[mean_name] = continent['MEAN']
            country_name = pd.merge(country_name,country[['NAME',sum_name,mean_name]],on='NAME',how='outer')
            continent_name = pd.merge(continent_name, continent[['CONTINENT', sum_name,mean_name]], on='CONTINENT', how='outer')
    country_name.to_csv('F:\junyu\zonal\\result\C{}_country_result.csv'.format(carbon_type))
    continent_name.to_csv('F:\junyu\zonal\\result\C{}_continent_result.csv'.format(carbon_type))



country = pd.read_csv('F:\junyu\zonal\\result\C1_country_result.csv')
continent = pd.read_csv('F:\junyu\zonal\\result\C1_continent_result.csv')
continent2 = pd.read_csv('F:\junyu\zonal\\result\C2_continent_result.csv')

for t in range(1,13):
    print('type\tC1\tC1')
    print('wetland{}\t{}\t{}'.format(t,sum(continent[['SUM_W{}_T{}_C1'.format(t,i) for i in range(1,4)]].sum().dropna().values)),sum(continent2[['SUM_W{}_T{}_C2'.format(t,i) for i in range(1,4)]].sum().dropna().values))















