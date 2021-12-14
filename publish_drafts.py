import os,glob,re
from datetime import datetime
import shutil

def publishFile(file):
    print(file)
    with open(file, 'r') as article:
        lines = article.read().splitlines()
        for line in lines:
            matched=re.match('date:(.*)',line)
            if(bool(matched)):
                datetime_object = datetime.fromisoformat(line[6:])
                basename=os.path.basename(file)
                dest=POSTS_FOLDER+datetime_object.strftime("%Y-%m-%-d")+"-"+basename
                print("basename",basename)
                shutil.copy(file,dest)   
                

def main():
    for file in glob.glob(DRAFTS_FOLDER+"/*.md", recursive = False):
        publishFile(file)

if __name__ == "__main__":
    DRAFTS_FOLDER = os.getenv('DRAFTS_FOLDER', '_drafts')
    POSTS_FOLDER = os.getenv('POSTS_FOLDER', '_posts')
    main()
