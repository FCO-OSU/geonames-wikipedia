require(tidyverse)
filter = dplyr::filter

# Download allCountries.zip and alternateNamesV2.zip from
# http://download.geonames.org/export/dump/ and unzip

setwd('~/Documents/data/geonames/geonames-wikipedia')

colnms = c('geonameid','name','asciiname','altnames','lat','lon','feature_class','feature_code',
             'country_code','cc2','admin1_code','admin2_code','admin3_code','admin4_code',
             'pop','elevation','dem','tz','date')

d = data.table::fread('allCountries.txt', sep = '\t', col.names = colnms) %>% as_data_frame()

an = data.table::fread('alternateNamesV2.txt', sep='\t', header=F) %>% 
  as_data_frame() %>% .[,1:4] %>% `names<-`(c('alternatenameid','geonameid','code','name'))

wiki_places = an %>% filter(code == 'link') %>% 
  select(-code) %>% rename(link = name) %>% 
  filter(str_detect(link, fixed('wiki'))) %>% 
  left_join(d, by = 'geonameid')

write_csv(wiki_places, 'wiki_places.csv')

system('tar -zcvf wiki_places.tar.gz wiki_places.csv')

# w = read_csv('wiki_places.csv')
# write_csv(w, 'geonames-wikipedia/wiki_places.csv')
