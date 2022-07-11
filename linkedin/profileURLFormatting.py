# A Script for the linkedin scraping pipeline 
# Removes duplicate URLs 
# removes irrelevant URLs 
# formats linkedin URLs 

import pandas as pd 
import os 

this_dir = os.getcwd()
url_file = f"{this_dir}/linkedin/linkedin_urls.txt"
out_file = f"{this_dir}/linkedin/linkedin_urls_clean.txt"

#read in df, remove duplicates
df = pd.read_csv(url_file, header=None,names=['url','category'])
df = df.drop_duplicates()

#we know that a valid profile url contains the linkedin.com/in/ syntax. we remove any URLs that don't fit this by creating a flag.
def isValidURL(url):
    return str(url.find("linkedin.com/in/") > -1)

df['is_valid'] = df['url'].map(isValidURL)

#remove invalid urls
df = df[df['is_valid']=='True']

#format everything else 
#the shape of a valid URL is https://www.linkedin.com/in/larissaqian?miniProfile... 
#we are only interested in everything before the question mark, provided it exists.
df['url'] = df['url'].apply(lambda x: x.split("?")[0])

#write to a text file using the .to_csv function.
df.to_csv(
    out_file, 
    header=None, 
    index=None, 
    sep=','
)