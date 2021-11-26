# Import some Windows Event logs (in evtx files) to Elastic 7.2+
# pip3 install evtxtoelk 
from evtxtoelk import EvtxToElk
import os
# change the next 2 constant to fit your environment
elastic = 'http://192.168.44.185:9200'
path_of_the_directory = "/home/hunter/Logs/evtx"
ext = '.evtx'  # filter the .evtx file only
for files in os.scandir(path_of_the_directory):
    if files.path.endswith(ext):
        print(files.path)
        EvtxToElk.evtx_to_elk(files.path, elastic)
