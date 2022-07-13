this_dir = "C:\\Users\\fkrasovsky\\OneDrive - Allvue Systems\\Documents\\usd\\capstone\\HigherME\\linkedin\\linkedin_urls_edu.txt"
import pandas as pd 

df = pd.read_csv(this_dir,header=None, sep = "!###!", engine="python",encoding = "ISO-8859-1")
df = df.drop_duplicates()
df['username'] = df[0].apply(lambda x: x.split("/")[4]+'.txt')


def to_own_txt(x):
    file_to_write_to = f"C:\\Users\\fkrasovsky\\OneDrive - Allvue Systems\\Documents\\usd\\capstone\\HigherME\\linkedin\\edu_data\\{x['username']}"
    obj = {
        "url": [x[0]],
        "html": [x[1]]
    }
    this_df = pd.DataFrame.from_dict(data=obj,orient='columns')
    this_df.to_csv(file_to_write_to, sep=str("@"),header=None,index=None)

df.apply(lambda x: to_own_txt(x),axis=1)